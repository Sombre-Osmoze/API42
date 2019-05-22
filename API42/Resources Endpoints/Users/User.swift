//
//  User.swift
//  API42
//
//  Created by Marcus Florentin on 17/01/2019.
//  Copyright © 2019 Marcus Florentin. All rights reserved.
//

import Foundation

public struct User: Codable {

	public let id : ID
	
	public let login : Login
	
	public let url : URL
	
}
