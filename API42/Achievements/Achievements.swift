//
//  Achievements.swift
//  API42
//
//  Created by Marcus Florentin on 18/01/2019.
//  Copyright © 2019 Marcus Florentin. All rights reserved.
//

import Foundation

public struct Achievements: Codable {

	public let id : ID
	public let name : String
	public let description : String
	public let tier : String
	public let kind : String
	public let visible : Bool
	public let image : URL
	public let nbrOfSuccess : Int?
	public let usersUrl : URL
}
