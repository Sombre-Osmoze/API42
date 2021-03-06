//
//  Token.swift
//  API42
//
//  Created by Marcus Florentin on 06/01/2019.
//  Copyright © 2019 Marcus Florentin. All rights reserved.
//

import Foundation
import Security

/// A 42 Api token
public class Token: CodingAPI {

	let token : String
	let type : String
	let creation : Date
	let scope : TokenScope
	let expiration : TimeInterval
	let refresh : String?

	enum KeychainError: Error {
		case noPassword
		case unexpectedPasswordData
		case unhandledError(status: OSStatus)
		case expired
	}

	enum TokenScope: String, CodingAPI {
		case standard = "public"
	}

	private enum CodingKeys: String, CodingKey {
		case token = "access_token"
		case type = "token_type"
		case creation = "created_at"
		case scope
		case expiration = "expires_in"
		case refresh = "refresh_token"
	}

	public init() throws {
		let query: [String: Any] = [kSecClass as String: kSecClassInternetPassword,
									kSecMatchLimit as String: kSecMatchLimitOne,
									kSecReturnAttributes as String: true,
									kSecReturnData as String: true,
									kSecAttrAccessible as String: kSecAttrAccessibleAlways,
									kSecAttrLabel as String: "token"]

		var item: CFTypeRef?
		let status = SecItemCopyMatching(query as CFDictionary, &item)
		guard status != errSecItemNotFound else {
			throw KeychainError.noPassword }
		guard status == errSecSuccess else {
			throw KeychainError.unhandledError(status: status) }


		guard let existingItem = item as? [String : Any],
			let tokenData = existingItem[kSecValueData as String] as? Data,
			let data = String(data: tokenData, encoding: .utf8)
			else {
				throw KeychainError.unexpectedPasswordData
		}

		let tokens = data.split(separator: ":")
		self.token = String(tokens[0])
		self.refresh = tokens.count == 2 ? String(tokens[1]) : nil


		self.expiration = TimeInterval(existingItem[kSecAttrComment as String] as! String)!
		self.creation = existingItem[kSecAttrCreationDate as String]  as! Date
		self.scope = TokenScope.standard
		self.type = existingItem[kSecAttrType as String]  as! String
	}

	public func store() throws -> Void {
		try? Token.delete()
		let password = "\(token):\(refresh ?? "")".data(using: .utf8)!
		let query: [String: Any] = [kSecClass as String: kSecClassInternetPassword,
									kSecValueData as String: password,
									kSecAttrAccount as String: "42 manage",
									kSecAttrServer as String: "api.intra.42.fr",
									kSecAttrDescription as String: scope.rawValue,
									kSecAttrProtocol as String : kSecAttrProtocolHTTPS,
									kSecAttrComment as String : expiration.description,
									kSecAttrCreationDate as String : creation,
									kSecAttrType as String : type,
									kSecAttrAccessible as String: kSecAttrAccessibleAlways,
									kSecAttrLabel as String: "token"]

		let status = SecItemAdd(query as CFDictionary, nil)
		guard status == errSecSuccess else {
			throw KeychainError.unhandledError(status: status)
		}
	}


	class func delete() throws -> Void {

		let query: [String: Any] = [kSecClass as String: kSecClassInternetPassword,
									kSecAttrServer as String: "api.intra.42.fr",
									kSecAttrAccessible as String: kSecAttrAccessibleAlways,
									kSecAttrLabel as String: "token"]

		let status = SecItemDelete(query as CFDictionary)
		guard status == errSecSuccess || status == errSecItemNotFound else
		{
			throw KeychainError.unhandledError(status: status)
		}
	}

	// MARK: - Equatable
	public static func == (lhs: Token, rhs: Token) -> Bool {

		guard lhs.expiration == rhs.expiration else { return false }

		guard lhs.creation == rhs.creation else { return false }

		guard lhs.type == rhs.type else { return false }

		guard lhs.scope == rhs.scope else { return false }

		guard lhs.token == rhs.token else { return false }

		guard lhs.refresh == rhs.refresh else { return false }

		return true
	}
}

