//
//  OutletConnectionsViewControllerTests.swift
//  OutletConnectionsViewControllerTests
//
//  Created by roberts.kursitis on 24/02/2023.
//

import XCTest
@testable import OutletConnections

final class OutletConnectionsViewControllerTests: XCTestCase {
	func test_outlets_shouldBeConnected() {
		let sut = OutletConnectionsViewController()
		
		sut.loadViewIfNeeded()
		
		XCTAssertNotNil(sut.label, "label")
		XCTAssertNotNil(sut.button, "button")
	}
}
