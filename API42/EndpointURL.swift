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

	/// We have a problem with our server.
	/// Please try again later.
	case serverError = 500

}


public struct Enpoint: CodingAPI {


	enum Endpoints: String {
		case me = "me"

		enum Users: String {
			case users = "users"
		}

		enum Components: String {
			case slots = "slots"
		}
	}

	var scope : URLProtectionSpace {
		return URLProtectionSpace(host: "api.intra.42.fr", port: 443, protocol: "https", realm: "42 API", authenticationMethod: NSURLAuthenticationMethodDefault)
	}

	var main: URL {
		return URL(string: "\(scope.protocol ?? "http")://\(scope.host)/\(version)/")!
	}
	
	let version = "v2"

	func endpoint(url type: Endpoints, component: Endpoints.Components? = nil) -> URL {

		var url = main.appendingPathComponent(type.rawValue)

		if let component = component {
			url.appendPathComponent(component.rawValue)
		}
		return url
	}

	func endpoint(url type: Endpoints.Users) -> URL {
		return main.appendingPathComponent(type.rawValue)
	}

}
