//
//  TitlesUsers.swift
//  API42
//
//  Created by Marcus Florentin on 18/01/2019.
//  Copyright © 2019 Marcus Florentin. All rights reserved.
//

import Foundation

public struct TitlesUsers: Codable {

	public let id : Int
	public let userId : Int
	public let titleId : Int
	public let selected : Bool
}
