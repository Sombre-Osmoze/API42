//
//  ControllerAPI.swift
//  API42
//
//  Created by Marcus Florentin on 05/01/2019.
//  Copyright © 2019 Marcus Florentin. All rights reserved.
//

import Foundation



public class ControllerAPI: Codable {

	let token : Token

	init() throws {
		token = try Token()
	}

	init(token: Token) {
		self.token = token
	}

}
