//
//  ProjectsUsers.swift
//  API42
//
//  Created by Marcus Florentin on 18/01/2019.
//  Copyright © 2019 Marcus Florentin. All rights reserved.
//

import Foundation

public struct ProjectsUsers: Codable {

	public let id : ID
	public let occurence : Int?
	public let finalMark : Int?
	public let status : String?
	public let isValidated : Bool?
	public let currentTeamId : ID?
	public let project : Project
	public let cursusIds : [ID]
	public let markedAt : Date?
	public let marked : Bool

	private enum CodingKeys: String, CodingKey {
		case id
		case occurence
		case finalMark
		case status
		case isValidated = "validated?"
		case currentTeamId
		case project
		case cursusIds
		case markedAt
		case marked
	}
}
