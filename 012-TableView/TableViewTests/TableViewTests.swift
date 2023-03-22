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
	
	func test_didSelectRow_withRow1() {
		didSelectRow(in: sut.tableView, row: 1)
//		sut.tableView.delegate?.tableView?(sut.tableView, didSelectRowAt: IndexPath(row: 1, section: 0))
		//assert smthn
	}
	
	func test_cellForRowAt_withRow0_shouldSetCellLabelToOne() {
		let cell = cellForRow(in: sut.tableView, row: 0)
		XCTAssertEqual(cell?.textLabel?.text, "One")
	}
	
	func test_cellForRowAt_withRow0_shouldSetCellLabelToTwo() {
		let cell = cellForRow(in: sut.tableView, row: 1)
		XCTAssertEqual(cell?.textLabel?.text, "Two")
	}
	
	func test_cellForRowAt_withRow0_shouldSetCellLabelToThree() {
		let cell = cellForRow(in: sut.tableView, row: 2)
		XCTAssertEqual(cell?.textLabel?.text, "Three")
	}
	
//	func test_cellForRowAt_withRow1_shouldSetCellLabelToTwo() {
//		let cell = sut.tableView.dataSource?.tableView(sut.tableView, cellForRowAt: IndexPath(row: 1, section: 0))
//		XCTAssertEqual(cell?.textLabel?.text, "Two")
//	}
	
	func test_numberOfRows_shouldBe3() {
		XCTAssertEqual(numberOfRows(in: sut.tableView), 3)
		//method called indirectly through the dataSource delegate.
	}
	
	func test_tableViewDelegates_shouldBeConnected() {
		XCTAssertNotNil(sut.tableView.dataSource, "dataSource")
		XCTAssertNotNil(sut.tableView.delegate, "delegate")
	}
}
