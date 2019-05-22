//
//  Slots.swift
//  API42
//
//  Created by Marcus Florentin on 22/05/2019.
//  Copyright © 2019 Marcus Florentin. All rights reserved.
//

import Foundation

/// A Slot is a time interval when a user desclares himself available to evaluate other users.
/// Actually, a slot must be at least 30 minutes (with a granularity of 15 minutes).
/// A slot can be set every day between 30 minutes and 2 weeks in advance.
public struct Slot {

	public let id : ID

	public let beginAt : Date

	public let endAt : Date

	// TODO: Find wich type is it
	public let scaleTeam : String?

	// TODO: Find wich type is it
	public let user : String

}
