//
//  ProjectSessions.swift
//  API42
//
//  Created by Marcus Florentin on 30/05/2019.
//  Copyright © 2019 Marcus Florentin. All rights reserved.
//

import Foundation

public struct ProjectSessions: CodingAPI {

	public let id : ID

	public let solo : Bool

	public let beginAt : Date

	public let endAt : Date

	public let estimateTime : TimeInterval

	// TODO: Get type
	public let durationDays : String?

	// TODO: Get type
	public let terminatingAfter : String?

	public let projectId : ID

	// TODO: Verify type
	public let campusId : ID?

	// TODO: Verify type
	public let cursus_id : ID?

	public let createdAt : Date

	public let updatedAt : Date

	// TODO: Get type
	public let maxPeople : String?

	public let isSubscriptable : Bool

//	public let
}
