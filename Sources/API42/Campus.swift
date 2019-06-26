//
//  Campus.swift
//  API42
//
//  Created by Marcus Florentin on 05/06/2019.
//  Copyright © 2019 Marcus Florentin. All rights reserved.
//

import Foundation

public struct Campus: CodingAPI {

	public let id : ID

	public let name : String

	// TODO: Try to decode a TimeZone from a String
	public let timeZone : String

	public let language : Language

	public let usersCount : Int

	public let vogsphereID : ID?
}
