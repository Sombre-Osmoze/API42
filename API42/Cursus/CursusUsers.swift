//
//  CursusUsers.swift
//  API42
//
//  Created by Marcus Florentin on 17/01/2019.
//  Copyright © 2019 Marcus Florentin. All rights reserved.
//

import Foundation

public struct CursusUsers: Codable {

	public let id : ID
	public let beginAt : Date
	public let endAt : Date?
	public let grade : String?
	public let level : Level
	public let skills : [Skill]
	// TODO: Verify below value
	public let cursusid : ID?
	public let hasCoalition : Bool
	public let user : User
	public let cursus : Cursus

}
