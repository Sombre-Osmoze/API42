//
//  ProjectInfo.swift
//  API42
//
//  Created by Marcus Florentin on 12/06/2019.
//

import Foundation

public struct ProjectInfo: CodingAPI {

	public let id : ID

	public let name : String

	public let slug : Slug

	public let parentId : ID?

}
