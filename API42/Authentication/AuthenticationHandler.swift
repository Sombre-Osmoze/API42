//
//  AuthenticationHandler.swift
//  API42
//
//  Created by Marcus Florentin on 17/01/2019.
//  Copyright © 2019 Marcus Florentin. All rights reserved.
//

import Foundation
import os.log

open class AuthenticationHandler: NSObject {

	public enum AuthStep: String {
		case none = "None"
		case oath2 = "Oath2"
		case token = "Token Storing"
		case session = "Controller init..."
		case owner = "User Information Fetch"
		case code = "API code"
		case terminated = "Terminated"
	}

	public var logs = OSLog(subsystem: "com.osmoze.Manage42", category: .pointsOfInterest)


	public let uid = ProcessInfo.processInfo.environment["API_UID"]!
	private let secret = ProcessInfo.processInfo.environment["API_SECRET"]!
	public let redirect = ProcessInfo.processInfo.environment["API_REDIRECT"]!

	public var owner : UserInformation? = nil
	public var controller : ControllerAPI? = nil
	public var error : Error? = nil

	public var step : AuthStep = .none {

		didSet {
			logging()
			handler(step, error)
		}

	}

	func logging() -> Void {

		if error == nil {
			os_log(.default, log: logs, "Authentication handling %s", step.rawValue)
		} else {
			os_log(.error, log: logs, "Error at step %s: %s", step.rawValue, error.debugDescription)
		}
	}

	private var handler : (_ step: AuthStep, _ error: Error?) -> Void = { _,_  in }

	public init(completion handler: @escaping(_ step: AuthStep, _ error: Error?) -> Void) {

		self.handler = handler

		super.init()
	}

	private func retreiveAuthCode() {

		if let cred = URLCredentialStorage.shared.defaultCredential(for: URLProtectionSpace(host: "api.intra.42.fr", port: 443, protocol: "https",
																							realm: "42 API", authenticationMethod: nil)), cred.hasPassword {
			step = .code
			obtainToken(auth: cred.password!)
		}
	}

	public func store(auth code: String) {

		step = .code
		let cred = URLCredential(user: "Manage42", password: code, persistence: .permanent)
		URLCredentialStorage.shared.setDefaultCredential(cred, for: URLProtectionSpace(host: "api.intra.42.fr", port: 443, protocol: "https", realm: "42 API", authenticationMethod: nil))
	}

	public func obtainToken(auth code: String) -> Void {
		let url = URL(string: "https://api.intra.42.fr/oauth/token")!

		let data = "grant_type=authorization_code&client_id=\(uid)&client_secret=\(secret)&code=\(code)&redirect_uri=\(redirect)".data(using: .utf8)!
		var request = URLRequest(url: url)

		request.httpMethod = "POST"
		request.httpBody = data

		let log = OSLog(subsystem: "com.osmoze.API42", category: "Authentication")
		os_signpost(.begin, log: log, name: "Token fetching")
		URLSession.shared.dataTask(with: request) { (data, response, error) in
			if error == nil, let status = response as? HTTPURLResponse {
				switch status.statusCode {
				case 200:
					do {
						let token = try JSONDecoder().decode(Token.self, from: data!)
						self.controller = ControllerAPI(token: token)
						self.step = .session
						self.controller?.ownerInformation(completion: { (owner, error) in
							self.owner = owner
							self.error = error
							self.step = .owner
							self.error = nil
						})
						try token.store()
					} catch {
						self.error = error
						self.step = AuthStep(rawValue: self.step.rawValue)!
						self.error = nil
					}
				default:
					os_signpost(.event, log: log, name: "Token fetching", "The server send status code: %d", status.statusCode)
				}
			}
			os_signpost(.end, log: log, name: "Token fetching")
		}.resume()

	}

}
