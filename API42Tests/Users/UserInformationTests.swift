//
//  UserInformationTests.swift
//  API42Tests
//
//  Created by Marcus Florentin on 05/06/2019.
//  Copyright © 2019 Marcus Florentin. All rights reserved.
//

import XCTest
@testable import API42


class UserInformationTests: XCTestCase {

	private lazy var decoder : JSONDecoder = {
		let dec = JSONDecoder()
		dec.keyDecodingStrategy = .convertFromSnakeCase
		let format = DateFormatter()
		format.calendar = Calendar(identifier: .iso8601)
		format.locale = Locale(identifier: "en_US_POSIX")
		format.timeZone = TimeZone(secondsFromGMT: 0)
		format.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
		dec.dateDecodingStrategy = .formatted(format)
		return dec
	}()

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }


	func testDecodable() {
		let file = Bundle(for: Self.self).url(forResource: "Me", withExtension: "json")
		guard file != nil, let data = try? Data(contentsOf: file!) else {
			XCTFail("Can't load test file")
			return
		}

		XCTAssertNoThrow(try decoder.decode(UserInformation.self, from: data), "Doesn't conforme to decodable protocol")
	}

}
