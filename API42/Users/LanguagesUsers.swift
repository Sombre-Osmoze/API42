//
//  LanguagesUsers.swift
//  API42
//
//  Created by Marcus Florentin on 18/01/2019.
//  Copyright © 2019 Marcus Florentin. All rights reserved.
//

import Foundation

public struct LanguagesUsers: Codable {
	public let id : ID
	public let languageid : ID
	public let userid : ID
	public let position : Int
	public let createdAt : Date
}
