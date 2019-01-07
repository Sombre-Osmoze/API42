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
enum ErrorURL: Int, Error {
	/// Forbidden
	case forbidden = 403
	/// Page or resource is not found
	case notFound = 404

}


public struct Enpoint {

	var scope : URLProtectionSpace {
		return URLProtectionSpace(host: "api.intra.42.fr", port: 443, protocol: "https", realm: "42 API", authenticationMethod: NSURLAuthenticationMethodDefault)
	}
	var main: String {
		return scope.protocol! + "://" + scope.host + "/" + version
	}

	let version = "v2"

}
