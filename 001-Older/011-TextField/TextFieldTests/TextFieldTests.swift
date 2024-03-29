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
		executeRunLoop()
		//using runLoop to help remove ViewControllers that stay alive past the end of all tests.
		sut = nil
		super.tearDown()
	}
	
	func test_shouldReturn_withPassword_shouldDismissKeyboard() {
		putInViewHierarchy(sut)
		sut.passwordField.becomeFirstResponder()
		XCTAssertTrue(sut.passwordField.isFirstResponder, "precindition")
		
		shouldReturn(in: sut.passwordField)
		
		XCTAssertFalse(sut.passwordField.isFirstResponder)
	}
	
	func test_shouldReturn_withUsername_shouldMoveInputFocusToPassword() {
		putInViewHierarchy(sut)
		shouldReturn(in: sut.usernameField)
		
		XCTAssertTrue(sut.passwordField.isFirstResponder)
	}
	
//	func test_shouldReturn_withPassword_shouldPerformLogin() {
//		sut.usernameField.text = "USERNAME"
//		sut.passwordField.text = "PASSWORD"
//
//		shouldReturn(in: sut.passwordField)
//	}
	
	func test_shouldChangeCharacters_passwordWithSpaces_shouldAllowChange() {
		let allowChange = shouldChangeCharacters(in: sut.passwordField, replacement: "a b")
		XCTAssertEqual(allowChange, true)
	}
	func test_shouldChangeCharacters_passwordWithoutSpaces_shouldAllowChange() {
		let allowChange = shouldChangeCharacters(in: sut.passwordField, replacement: "abc")
		XCTAssertEqual(allowChange, true)
	}
	
	func test_shouldChangeCharacters_usernameWithoutSpaces_shouldAllowChange() {
		let allowChange = shouldChangeCharacters(in: sut.usernameField, replacement: "abc")
		XCTAssertEqual(allowChange, true)
	}
	
	func test_shouldChangeCharacters_usernameWithSpaces_shouldPreventChange() {
		let allowChange = shouldChangeCharacters(in: sut.usernameField, replacement: "a b")
		XCTAssertEqual(allowChange, false)
	}
	
	func test_textFieldDelegates_shouldBeConnected() {
		XCTAssertNotNil(sut.usernameField.delegate, "usernameField")
		XCTAssertNotNil(sut.passwordField.delegate, "passwordField")
	}
	
	func test_passwordField_attributesShouldBeSet() {
		let textField = sut.passwordField!
		XCTAssertEqual(textField.textContentType, .password, "textContentType")
		XCTAssertEqual(textField.returnKeyType, .go, "returnKeyType")
		XCTAssertTrue(textField.isSecureTextEntry, "isSecureTextEntry")
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
