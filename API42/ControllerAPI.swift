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

public class ControllerAPI: NSObject, Codable, URLSessionDelegate, URLSessionTaskDelegate {

	/// The controller 42's API token
	private var token : Token!

	/// Structure to get enpoints urls
	private let endpoints = Enpoint()

	/// Default event logger
	private var logger : OSLog! { return .init(subsystem: "com.osmoze.API42", category: .pointsOfInterest) }

	/// Logger for sign post logs
	private var logging : OSLog! { return .init(subsystem: "com.osmoze.API42", category: "ControllerAPI") }

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

	public func logout() {
		session.invalidateAndCancel()
		try? Token.delete()
	}

	private func prepare(request url: URL) -> URLRequest {
		var request = URLRequest(url: url)
		request.setValue("\(token.type.capitalized) \(token.token)", forHTTPHeaderField: "Authorization")
		return request
	}

	private func validate(_ task: URLSessionTask) -> Void {

		/// The token expiration date
		let tokenLimit = token.creation.addingTimeInterval(token.expiration)

		// Check token validity.
		// Can use `creation.timeIntervalSinceNow.magnitude < expiration`
		guard tokenLimit.timeIntervalSinceNow.sign == .plus else {
			os_log(.debug, log: logger, "Token has expired")

			// TODO: Refresh token
//			session.dataTask(with: <#T##URLRequest#>)

			return
		}


		// Execute the task
		task.resume()
	}

	// MARK: Request & Error handling

	private func verify(request response: URLResponse?, data: Data? = nil, error: Error?) throws -> Void {

		guard error == nil else {
			try handle(error!)
			throw error!
		}

		guard let reponse = response as? HTTPURLResponse else { return }


		if reponse.statusCode != 200, let error = RequestError(rawValue: reponse.statusCode) {
			try handle(error)
			throw error
		}

		guard let data = data, data.count == Int(reponse.expectedContentLength) else {
			throw RequestFault.corruptedData
		}

	}

	private func handle(_ error: Error) throws -> Void {

		switch error {
		case (let request as RequestError): break
			// TODO: Handle http classique error

		default:
			os_log(.fault, log: logger, "Unhandled error: %s", error.localizedDescription)
		}
	}

	// MARK: User

	public func ownerInformation( handler: @escaping(_ owner: UserInformation?, _ error: Error?) -> Void) -> Void {

		os_signpost(.begin, log: logging, name: "Owner information fetching")
		let task = session.dataTask(with: prepare(request: endpoints.endpoint(url: .me))) { (data, response, error) in
			do {
				try self.verify(request: response, error: error)
				handler(try self.decoder.decode(UserInformation.self, from: data!), nil)
			} catch (let error) {
				os_signpost(.event, log: self.logging, name: "Owner Information Fetching", "A decoding error occur: %s", error.localizedDescription)
				handler(nil, error)
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

	func userInformation(id: ID,  handler: @escaping(_ user: UserInformation?, _ error: Error?) -> Void) -> Void {
		var url = endpoints.endpoint(url: .users)
		url.appendPathComponent(id.description)

		os_signpost(.begin, log: logging, name: "User information fetching", "User: %d", id)
		let task = session.dataTask(with: prepare(request: url)) { (data, response, error) in

			do {
				try self.verify(request: response, error: error)
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



	// MARK: Search API

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

	func ownerSlots(handler: @escaping(_ result: Result<[Slot], Error>) -> Void) -> Void {

		os_signpost(.begin, log: logging, name: "Owner slots fetching")
		let task = session.dataTask(with: prepare(request: endpoints.endpoint(url: .me, component: .slots))) { (data, response, error) in

			do {
				try self.verify(request: response, error: error)
			} catch let err {
				handler(.failure(err))
			}

			os_signpost(.end, log: self.logging, name: "Owner slots fetching")
		}

		validate(task)
	}


	
}
