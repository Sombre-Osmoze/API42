//
//  Cursus.swift
//  API42
//
//  Created by Marcus Florentin on 17/01/2019.
//  Copyright © 2019 Marcus Florentin. All rights reserved.
//

import Foundation

public struct Cursus: Codable {

	public let id : ID
	public let name : String
	public let createdAt : Date
	public let slug : Slug

}
