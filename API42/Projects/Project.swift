//
//  Project.swift
//  API42
//
//  Created by Marcus Florentin on 18/01/2019.
//  Copyright © 2019 Marcus Florentin. All rights reserved.
//

import Foundation

public struct Project: Codable {

	public let id : Int
	public let name : String
	public let slug : Slug
	public let parentID : Int?
}
