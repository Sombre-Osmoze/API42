//
//  Authentication.swift
//  API42Tests
//
//  Created by Marcus Florentin on 14/01/2019.
//  Copyright © 2019 Marcus Florentin. All rights reserved.
//

import XCTest
@testable import API42

class Authentication: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

	func testStoreCredential() {

		let token = Token("1fed70378d48b4a31d7713d3ad2923fc466a7410ac5d9e11e0ee74f031422159",
						  type: "bearer", creation: Date(), scope: .standard, expiration: 7200)

		do {
			try token.store()
		} catch {
			XCTFail(error.localizedDescription)
		}
	}
}
