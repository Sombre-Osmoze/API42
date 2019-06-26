//
//  EndpointURL.swift
//  API42
//
//  Created by Marcus Florentin on 04/01/2019.
//  Copyright © 2019 Marcus Florentin. All rights reserved.
//

import Foundation
import Security

public struct Enpoint: CodingAPI {

	enum Endpoints: String {
		case me = "me"

		enum Auth: String {
			case token = "token"
		}

		enum Users: String {
			case users = "users"
		}
		case projects = "projects"
		case slots = "slots"

	}

	var scope : URLProtectionSpace {
		return URLProtectionSpace(host: "api.intra.42.fr", port: 443, protocol: "https", realm: "42 API", authenticationMethod: NSURLAuthenticationMethodDefault)
	}

	var main: URL {
		return URL(string: "\(scope.protocol ?? "http")://\(scope.host)/\(version)/")!
	}
	
	let version = "v2"

	func endpoint(url type: Endpoints.Auth) -> URL {
		var url = main.appendingPathComponent("auth")
		url.appendPathComponent(type.rawValue)
		return url
	}


	func endpoint(url type: Endpoints, items: Set<URLQueryItem> = []) -> URL {
		var components = URLComponents(url: main, resolvingAgainstBaseURL: true)!
		components.queryItems?.append(contentsOf: items)
		return components.url!.appendingPathComponent(type.rawValue)
	}



	/// This function gives a url corresponding to the
	///
	/// - Parameter type: The requested endpoint
	/// - Returns: The url for the requested 'Users' endpoint
	func endpoint(url type: Endpoints.Users) -> URL {
		return main.appendingPathComponent(type.rawValue)
	}

}
