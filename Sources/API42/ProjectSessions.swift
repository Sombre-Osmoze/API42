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

	public let beginAt : Date?

	public let endAt : Date?

	public let estimateTime : TimeInterval?

	public let durationDays : Int?

	public let terminatingAfter : TimeInterval?

	public let projectId : ID

	public let campusId : ID?

	public let cursus_id : ID?

	public let createdAt : Date

	public let updatedAt : Date

	public let maxPeople : Int?

	public let isSubscriptable : Bool

//	public let
}
