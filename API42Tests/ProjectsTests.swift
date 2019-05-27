//
//  ProjectsTests.swift
//  API42Tests
//
//  Created by Marcus Florentin on 27/05/2019.
//  Copyright © 2019 Marcus Florentin. All rights reserved.
//

import XCTest
@testable import API42

class ProjectsTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

	private lazy var decoder : JSONDecoder = {
		let dec = JSONDecoder()
		dec.keyDecodingStrategy = .convertFromSnakeCase
		let format = DateFormatter()
		format.calendar = Calendar(identifier: .iso8601)
		format.locale = Locale(identifier: "en_US_POSIX")
		format.timeZone = TimeZone.autoupdatingCurrent
		format.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
		dec.dateDecodingStrategy = .formatted(format)
		return dec
	}()

	/// Test if the slot structure is conforme to the Codable protocol.
	func testCodable() {

		/// A Project structure
		let project = Project(id: 1, name: "Test", slug: "Test", parentid: nil)

		var data : Data! = nil
		var result : Project! = nil

		XCTAssertNoThrow(data = try JSONEncoder().encode(project), "Not conforme to encodable protocol")

		XCTAssertNoThrow(result = try JSONDecoder().decode(Project.self, from: data), "Not conforme to encodable protocol")

		guard result != nil else { return }

		XCTAssertEqual(project, result, "After encoding and decoding the data are not the same")

	}

	func testDecodable() {
		let file = URL(fileURLWithPath: "Project.json")
		guard let data = try? Data(contentsOf: file) else {
			XCTFail("Can't load test file")
			return
		}

		XCTAssertNoThrow(try decoder.decode(Project.self, from: data), "Doesn't conforme to decodable protocol")
	}

	

}
