//
//  ViewControllerTests.swift
//  ViewControllerTests
//
//  Created by roberts.kursitis on 06/03/2023.
//

import XCTest
@testable import UserDefaultsTests

final class ViewControllerTests: XCTestCase {
	private var sut: ViewController!
	private var defaults: FakeUserDefaults!
	
	override func setUp() {
		super.setUp()
		let storyboard = UIStoryboard(name: "Main", bundle: nil)
		sut = storyboard.instantiateViewController(identifier: String(describing: ViewController.self))
		defaults = FakeUserDefaults()
		sut.userDefaults = defaults
	}
	
	override func tearDown() {
		sut = nil
		defaults = nil
		super.tearDown()
	}

	func test_viewDidLoad_with7InUserDefaults_shouldShow7InCounterLabel() {
		defaults.integers = ["count": 7]
		
		sut.loadViewIfNeeded()
		
		XCTAssertEqual(sut.counterLabel.text, "7")
	}
	
	func test_tappingButton_with42InUserDefaults_shouldShow43InCounterLabel() {
		defaults.integers = ["count": 42]
		sut.loadViewIfNeeded()
		
		tap(sut.incrementButton)
		
		XCTAssertEqual(sut.counterLabel.text, "43")
	}

}
