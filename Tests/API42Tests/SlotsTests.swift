//
//  Slots.swift
//  API42Tests
//
//  Created by Marcus Florentin on 22/05/2019.
//  Copyright © 2019 Marcus Florentin. All rights reserved.
//

import XCTest
@testable import API42

class SlotsTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

	// MARK: - Codable

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

		/// A Slot structure
		let slot = Slot(id: 1, beginAt: Date(timeIntervalSinceReferenceDate: 5),
						endAt: Date(timeIntervalSinceReferenceDate: 125),
						scaleTeam: nil,
						user: "invisible")
 
		var data : Data! = nil
		var result : Slot! = nil

		XCTAssertNoThrow(data = try JSONEncoder().encode(slot), "Not conforme to encodable protocol")

		XCTAssertNoThrow(result = try JSONDecoder().decode(Slot.self, from: data), "Not conforme to encodable protocol")

		guard result != nil else { return }

		XCTAssertEqual(slot, result, "After encoding and decoding the data are not the same")

	}

	/// Test if the slot structure is conforme to Decodable proctocole with some API datas.
	func testDecodable() {

		/// A slot's datas in UTF-8 format
		let slotData = """
{
	"id": 27,
	"begin_at": "2017-11-24T20:15:00.000Z",
	"end_at": "2017-11-24T20:30:00.000Z",
	"scale_team": null,
	"user": "invisible"
}
""".data(using: .utf8)!

		XCTAssertNoThrow(try decoder.decode(Slot.self, from: slotData), "Doesn't conforme to decodable protocol")

	}

}
