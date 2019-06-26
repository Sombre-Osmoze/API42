//
//  Project.swift
//  API42
//
//  Created by Marcus Florentin on 18/01/2019.
//  Copyright © 2019 Marcus Florentin. All rights reserved.
//

import Foundation

public struct Project: CodingAPI {

	public let id : ID
	
	public let name : String
	
	public let slug : Slug
	
	public let parent : ProjectInfo?

	// TODO: Get type (maybe project info)
	public let children : [String]?

	public let objectives : [String]?

	public let tier : Int?

	public let attachments : [Attachments]?

	public let createdAt : Date?

	public let updatedAt : Date?

	public let exam : Bool?

	public let cursus : [Cursus]?

	public let campus : [Campus]?

	public let skills : [Skill]?

	// TODO: Get type
	public let videos : [String]?

	public let tags : [Tag]

	public let projectSessions : [ProjectSessions]?

}
