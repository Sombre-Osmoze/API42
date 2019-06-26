//
//  Language.swift
//  API42
//
//  Created by Marcus Florentin on 05/06/2019.
//  Copyright © 2019 Marcus Florentin. All rights reserved.
//

import Foundation

public struct Language: CodingAPI {

	public let id : ID

	public let name : String

	public let identifier : String

	public let createdAt : Date?

	public let updatedAt : Date?
}
