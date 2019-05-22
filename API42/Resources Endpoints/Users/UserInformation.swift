//
//  UserInformation.swift
//  API42
//
//  Created by Marcus Florentin on 08/01/2019.
//  Copyright © 2019 Marcus Florentin. All rights reserved.
//

import Foundation


/// Show the current resource owner
public struct UserInformation: CodingAPI {

	public let id : ID

	public let email : String

	public let login : String

	public let firstName : String

	public let lastName : String

	public let url : URL

	public let phone : String?

	public let displayName : String

	public let imageUrl : URL?

	public var image : Data?

	public let isStaff : Bool?

	public let correctionPoint : Int

	public let poolMonth : String

	public let poolYear : String

	public let location : String?

	public let wallet : Int

	public let groups : [Group]

	public let cursusUsers : [CursusUsers]

	public let projectsUsers : [ProjectsUsers]

	public let achievements : [Achievements]

	public let titles : [Titles]

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
		case groups
		case cursusUsers
		case projectsUsers
		case achievements
		case titles
	}
}
