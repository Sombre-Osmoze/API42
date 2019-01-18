//
//  Token.swift
//  API42
//
//  Created by Marcus Florentin on 06/01/2019.
//  Copyright © 2019 Marcus Florentin. All rights reserved.
//

import Foundation
import Security

enum KeychainError: Error {
	case noPassword
	case unexpectedPasswordData
	case unhandledError(status: OSStatus)
	case expired
}


enum TokenScope: String, Codable {
	case standard = "public"
}

public class Token: Codable {

	let token : String
	let type : String
	let creation : Date
	let scope : TokenScope
	let expiration : TimeInterval

	enum CodingKeys: String, CodingKey {
		case token = "access_token"
		case type = "token_type"
		case creation = "created_at"
		case scope
		case expiration = "expires_in"
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
			let token = String(data: tokenData, encoding: String.Encoding.utf8)
//			let expiration = existingItem[kSecAttrComment as String] as? String

			else {
				throw KeychainError.unexpectedPasswordData
		}



//		print(existingItem[ as String])


		self.token = token
		self.expiration = TimeInterval(7200)
		self.creation = existingItem[kSecAttrCreationDate as String]  as! Date
//		guard creation >= creation.addingTimeInterval(expiration) else {
//			try Token.delete()
//			throw KeychainError.expired
//		}
		self.scope = TokenScope.standard
		self.type = "bearer"
	}

	init(_ token: String, type: String, creation: Date, scope: TokenScope, expiration: TimeInterval) {
		self.token = token
		self.type = type
		self.creation = creation
		self.scope = scope
		self.expiration = expiration
	}

	public func store() throws -> Void {
		try? Token.delete()
		let password = token.data(using: .utf8)!

		let query: [String: Any] = [kSecClass as String: kSecClassInternetPassword,
									kSecValueData as String: password,
									kSecAttrAccount as String: "mflorent",
									kSecAttrServer as String: "api.intra.42.fr",
									kSecAttrDescription as String: scope.rawValue,
									kSecAttrProtocol as String : kSecAttrProtocolHTTPS,
//									kSecAttrComment as String : expiration.description,
//									kSecAttrCreationDate as String : DateFormatter().string(from: creation),
//									kSecAttrType as String : type,
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
}
