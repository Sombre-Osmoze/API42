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
	
	public let parent : ID?

	// TODO: Get type
	public let children : [String]?

	public let objectives : [String]?

	public let tier : Int?

	// TODO: Get type
	public let attachments : [String]?

	public let createdAt : Date?

	public let updatedAt : Date?

	public let exam : Bool?

	public let cursus : [Cursus]?

	// TODO: Create `Campus`
	public let campus : [Campus]?

	public let skills : [Skill]?

	// TODO: Get type
	public let videos : [String]?

	// TODO: Get type
	public let tags : [String]?

	// TODO: Get type
	public let projectSessions : [String]?

}
