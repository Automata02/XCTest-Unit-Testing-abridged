//
//  TextFieldTests.swift
//  TextFieldTests
//
//  Created by roberts.kursitis on 15/03/2023.
//

import XCTest
@testable import TextField

final class TextFieldTests: XCTestCase {
	private var sut: ViewController!
	
	override func setUp() {
		super.setUp()
		let storyboard = UIStoryboard(name: "Main", bundle: nil)
		sut = storyboard.instantiateViewController(identifier: String(describing: ViewController.self))
		sut.loadViewIfNeeded()
	}
	
	override func tearDown() {
		sut = nil
		super.tearDown()
	}
	
	func test_usernameTextField_attributesShouldBeSet() {
		let textField = sut.usernameField!
		XCTAssertEqual(textField.textContentType, .username, "textContentType")
		XCTAssertEqual(textField.autocorrectionType, .no, "autocorrectionType")
		XCTAssertEqual(textField.returnKeyType, .next, "returnKeyType")
	}
	
	func test_outlets_shouldBeConnected() {
		XCTAssertNotNil(sut.usernameField, "usernameField")
		XCTAssertNotNil(sut.passwordField, "passwordField")
	}
}
