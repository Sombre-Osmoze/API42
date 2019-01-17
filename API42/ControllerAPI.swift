//
//  ControllerAPI.swift
//  API42
//
//  Created by Marcus Florentin on 05/01/2019.
//  Copyright © 2019 Marcus Florentin. All rights reserved.
//

import Foundation



public class ControllerAPI: NSObject, Codable, URLSessionDelegate {

	let token : Token
	private let endpoints = Enpoint()
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

	private var session : URLSession {
		return URLSession(configuration: .default, delegate: self, delegateQueue: .init())
	}

//	public override init?() {
//
//		do {
//			token = try Token()
//		} catch {
//			return nil
//		}
//		super.init()
//	}

	private func prepare(request url: URL) -> URLRequest {
		var request = URLRequest(url: url)

		request.setValue("\(token.type.capitalized) \(token.token)", forHTTPHeaderField: "Authorization")

		return request
	}

	public init(token: Token) {
		self.token = token
		super.init()
	}

	public func ownerInformation(completion handler: @escaping(_ owner: UserInformation?, _ error: Error?) -> Void) -> Void {

		session.dataTask(with: prepare(request: endpoints.endpoint(url: .me))) { (data, response, error) in

			if error == nil, let data = data {
				do {
					handler(try self.decoder.decode(UserInformation.self, from: data), nil)
				} catch {
					handler(nil, error)
				}
			} else {
				handler(nil, error)
			}
		}.resume()

	}

	public func user(image url: URL, completion handler: @escaping(_ image: Data?, _ error: Error?) -> Void) -> Void {
		// TODO: Change code
		session.dataTask(with: url) { (data, response, error) in
			handler(data, error)
		}.resume()
	}

}
