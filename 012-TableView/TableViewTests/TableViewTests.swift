//
//  TableViewTests.swift
//  TableViewTests
//
//  Created by roberts.kursitis on 21/03/2023.
//

import XCTest
@testable import TableView

final class TableViewTests: XCTestCase {
	var sut: TableViewController!
	
	override func setUp() {
		super.setUp()
		let storyboard = UIStoryboard(name: "Main", bundle: nil)
		sut = storyboard.instantiateViewController(identifier: String(describing: TableViewController.self))
		sut.loadViewIfNeeded()
	}

	override func tearDown() {
		sut = nil
		super.tearDown()
	}
	
	func test_tableViewDelegates_shouldBeConnected() {
		XCTAssertNotNil(sut.tableView.dataSource, "dataSource")
		XCTAssertNotNil(sut.tableView.delegate, "delegate")
	}
}
