//
//  EndpointURL.swift
//  API42
//
//  Created by Marcus Florentin on 04/01/2019.
//  Copyright © 2019 Marcus Florentin. All rights reserved.
//

import Foundation
import Security

/// Error codes used by the 42 API
enum RequestError: Int, Error {
	/// The request is malformed
	case badRequest = 400
	/// Unauthorized
	case unauthorized = 401
	/// Forbidden
	case forbidden = 403
	/// Page or resource is not found
	case notFound = 404
	/// Unprocessable entity
	case unprocessable = 422
	/// We have a problem with our server. Please try again later.
	case serverError = 500
}


public struct Enpoint: Codable {


	enum Endpoints {
		case me
		enum Users {
			case users
		}
	}

	var scope : URLProtectionSpace {
		return URLProtectionSpace(host: "api.intra.42.fr", port: 443, protocol: "https", realm: "42 API", authenticationMethod: NSURLAuthenticationMethodDefault)
	}
	var main: String {
		return scope.protocol! + "://" + scope.host + "/" + version + "/"
	}

	let version = "v2"

	func endpoint(url type: Endpoints) -> URL {
		switch type {
		case .me:
			return URL(string: main + "me")!
		}
	}

	func endpoint(url type: Endpoints.Users) -> URL {
		switch type {
		case .users:
			return URL(string: main + "users")!
		}
	}

}
