//
//  ControllerAPI.swift
//  API42
//
//  Created by Marcus Florentin on 05/01/2019.
//  Copyright © 2019 Marcus Florentin. All rights reserved.
//

import Foundation

// Logging
import os.log
import os.signpost

@available(iOS 12.0, *, macOS 10.14, *)
open class ControllerAPI: NSObject, URLSessionDelegate, URLSessionTaskDelegate {

	/// The controller 42's API token
	private var token : Token!

	/// Structure to get enpoints urls
	private let endpoints = Enpoint()

	/// Default event logger
	private var logger : OSLog! { return .init(subsystem: "com.osmoze.API42", category: .pointsOfInterest) }

	/// Logger for sign post logs
	private var logging : OSLog! { return .init(subsystem: "com.osmoze.API42", category: "ControllerAPI") }

	private var encoder : JSONEncoder {
		let enc = JSONEncoder()
		enc.keyEncodingStrategy = .convertToSnakeCase
		return enc
	}

	private var decoder : JSONDecoder {
		let dec = JSONDecoder()
		dec.keyDecodingStrategy = .convertFromSnakeCase
		let format = DateFormatter()
		format.calendar = Calendar(identifier: .iso8601)
		format.locale = Locale(identifier: "en_US_POSIX")
		format.timeZone = TimeZone.autoupdatingCurrent
		format.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
		dec.dateDecodingStrategy = .formatted(format)
		return dec
	}

	public override init() {

		do {
			token = try Token()
		} catch {
			token = nil
		}
		super.init()
	}

	public init(token: Token) {
		self.token = token
		super.init()
	}

	open func logout() {
		pendingTask.removeAll()
		session.invalidateAndCancel()
		try? Token.delete()
	}

	private func prepare(request url: URL) -> URLRequest {
		var request = URLRequest(url: url)
		request.setValue("\(token.type.capitalized) \(token.token)", forHTTPHeaderField: "Authorization")
		return request
	}

	private var refreshTask : URLSessionDataTask? = nil
	private var pendingTask : [URLSessionTask] = []

	private func validate(_ task: URLSessionTask) -> Void {

		/// The token expiration date
		let tokenLimit = token.creation.addingTimeInterval(token.expiration)

		// Check token validity.
		// Can use `creation.timeIntervalSinceNow.magnitude >= expiration`
		guard tokenLimit.timeIntervalSinceNow.sign == .minus else {

			// Execute the task
			task.resume()
			return
		}

		os_log(.debug, log: logger, "Token has expired")

		// Add the taks to the pending list
		pendingTask.append(task)

		guard token.refresh != nil else {
			logout()
			os_log(.info, log: logger, "Logout")
			return
		}

		refreshToken()
	}



	private func refreshToken() -> Void {

		guard refreshTask == nil, let refresh = token.refresh else { return }

		let auth = AuthenticationHandler { _,_ in }
		let refreshToken = auth.refresh(refresh: refresh)

		var request = prepare(request: endpoints.endpoint(url: .token))

		request.httpMethod = "POST"
		request.setValue("application/json", forHTTPHeaderField: "Content-Type")
		request.httpBody = try? encoder.encode(refreshToken)

		os_signpost(.begin, log: logging, name: "Refreshing token")
		refreshTask = session.dataTask(with: request, completionHandler: { (data, response, error) in

			do {
				try self.verify(request: response, data: data, error: error)
				self.token = try self.decoder.decode(Token.self, from: data!)

				os_log(.info, log: self.logger, "Token refreshed on %s", self.token.creation.debugDescription)
				self.pendingTask.removeAll(where: { (task) -> Bool in
					task.resume()
					return true
				})

				try self.token.store()
				os_log(.debug, log: self.logger, "Token stored")
			} catch let err {
				print(err)
				self.logout()
			}
			os_signpost(.end, log: self.logging, name: "Refreshing token")
		})

		refreshTask!.priority = URLSessionTask.highPriority
		refreshTask!.resume()
	}


	// MARK: - Request & Error handling

	@discardableResult private func  verify(request response: URLResponse?, data: Data? = nil, error: Error?) throws -> Data? {

		guard error == nil else {
			try handle(error!)
			throw error!
		}

		guard let reponse = response as? HTTPURLResponse else { throw RequestFault.corruptedData }


		if reponse.statusCode != 200, let error = RequestError(rawValue: reponse.statusCode) {
			try handle(error)
			throw error
		}

		guard let data = data, data.count == Int(reponse.expectedContentLength) else {
			throw RequestFault.corruptedData
		}

		return data
	}

	private func handle(_ error: Error) throws -> Void {

		switch error {
		case (let request as RequestError):
			switch request {
			case .forbidden: os_log(.error, log: logger, "The resources are forbidden")
			case .badRequest: os_log(.error, log: logger, "I bad request was made")
			case .notFound: os_log(.error, log: logger, "The request was not found")
			case .serverError: os_log(.error, log: logger, "The server encounter a error")
			case .unauthorized: os_log(.error, log: logger, "The user is unauthorized")
			case .unprocessable: os_log(.error, log: logger, "The request was unprocesable")
			}

		default:
			os_log(.fault, log: logger, "Unhandled error: %s", error.localizedDescription)
		}
	}

	// MARK: - User

	public func ownerInformation( handler: @escaping(_ owner: UserInformation?, _ error: Error?) -> Void) -> Void {

		os_signpost(.begin, log: logging, name: "Owner information fetching")
		let task = session.dataTask(with: prepare(request: endpoints.endpoint(url: .me))) { (data, response, error) in
			do {
				try self.verify(request: response, data: data, error: error)
				handler(try self.decoder.decode(UserInformation.self, from: data!), nil)
			} catch (let err) {
				os_signpost(.event, log: self.logging, name: "Owner Information Fetching", "A error occured: %s", err.localizedDescription)
				handler(nil, err)
			}
			os_signpost(.end, log: self.logging, name: "Owner Information Fetching")
		}

		validate(task)
	}

	public func user(image url: URL,  handler: @escaping(_ image: Data?, _ error: Error?) -> Void) -> Void {
		// TODO: Change code

		os_signpost(.begin, log: logging, name:  "User image fetching")
		let task = session.dataTask(with: url) { (data, response, error) in
			handler(data, error)
			os_signpost(.end, log: self.logging, name:  "User image fetching")
		}

		validate(task)
	}

	public func userInformation(id: ID,  handler: @escaping(_ user: UserInformation?, _ error: Error?) -> Void) -> Void {
		var url = endpoints.endpoint(url: .users)
		url.appendPathComponent(id.description)

		os_signpost(.begin, log: logging, name: "User information fetching", "User: %d", id)
		let task = session.dataTask(with: prepare(request: url)) { (data, response, error) in

			do {
				try self.verify(request: response, data: data, error: error)
				handler(try self.decoder.decode(UserInformation.self, from: data!), nil)
			} catch (let error) {
				handler(nil, error)
				os_signpost(.event, log: self.logging, name: "User information fetching", "Decoding error: %s", error.localizedDescription)
			}
			os_signpost(.begin, log: self.logging, name: "User information fetching")
		}

		validate(task)
	}

	// MARK: - URL Session Delegate

	private var session : URLSession {
		let queue = OperationQueue()
		queue.qualityOfService = .userInitiated
		return URLSession(configuration: .default, delegate: self, delegateQueue: queue)
	}



	// MARK: - Search API

	public func search(user login: Login, page: Int,   handler: @escaping(_ users: [User]?, _ error: Error? ) -> Void) -> Void {

//		var url = endpoints.endpoint(url: .users)

		let url = URL(string: "https://api.intra.42.fr/v2/users/?page=\(page)&sort=login&range[login]=\(login),z)")!

		let task = session.dataTask(with: prepare(request: url)) { (data, resp, error) in

			if error == nil, let data = data, let response = resp as? HTTPURLResponse {
				if response.statusCode == 200 {
					do {
						handler(try self.decoder.decode([User].self, from: data), nil)
					} catch {
						handler(nil, error)
					}
				}
			} else {
				handler(nil, error)
			}
		}

		validate(task)
	}

	// MARK: - Slots

	public func ownerSlots(handler: @escaping(_ result: Result<[Slot], Error>) -> Void) -> Void {

		os_signpost(.begin, log: logging, name: "Owner slots fetching")
		let task = session.dataTask(with: prepare(request: endpoints.endpoint(url: .me, component: .slots))) { (data, response, error) in

			do {
				try self.verify(request: response, data: data, error: error)
				handler(.success(try self.decoder.decode([Slot].self, from: data!)))
			} catch let err {
				handler(.failure(err))
			}

			os_signpost(.end, log: self.logging, name: "Owner slots fetching")
		}

		validate(task)
	}


	// MARK: - Projects

	public func projects(handler: @escaping(_ result: Result<[Project], Error>) -> Void) -> Void {

		os_signpost(.begin, log: logging, name: "Projects fetching")
		let task = session.dataTask(with: prepare(request: endpoints.endpoint(url: .me, component: .slots))) { (data, response, error) in

			do {
				try self.verify(request: response, data: data, error: error)
				handler(.success(try self.decoder.decode([Project].self, from: data!)))
			} catch let err {
				handler(.failure(err))
			}

			os_signpost(.end, log: self.logging, name: "Projects fetching")
		}

		validate(task)
	}

}
