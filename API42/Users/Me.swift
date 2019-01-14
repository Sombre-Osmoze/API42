//
//  Me.swift
//  API42
//
//  Created by Marcus Florentin on 08/01/2019.
//  Copyright © 2019 Marcus Florentin. All rights reserved.
//

import Foundation

public typealias Level = Float

/// Show the current resource owner
public struct Me: Codable {

	public let id : Int

	public let email : String

	public let login : String

	public let firstName : String

	public let lastName : String

	public let url : URL

	public let phone : String?

	public let displayName : String

	public let imageUrl : URL?

	public let isStaff : Bool

	public let correctionPoint : Int

	public let poolMonth : String

	public let poolYear : String

	public let location : String?

	public let wallet : Int

	// TODO : Implement Group
//	public let groups : [String]

//	public let cursusUsers : [String]

	private enum CodingKeys: String, CodingKey {
		case displayName = "displayname"
		case isStaff = "staff?"
		case id
		case email
		case login
		case firstName
		case lastName
		case url
		case phone
		case imageUrl
		case correctionPoint
		case poolMonth
		case poolYear
		case location
		case wallet
	}
}
