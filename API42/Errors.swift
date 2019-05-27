//
//  Errors.swift
//  API42
//
//  Created by Marcus Florentin on 27/05/2019.
//  Copyright © 2019 Marcus Florentin. All rights reserved.
//

import Foundation


// MARK: - Requests

public enum RequestFault: Error {
	case corruptedData
}

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
