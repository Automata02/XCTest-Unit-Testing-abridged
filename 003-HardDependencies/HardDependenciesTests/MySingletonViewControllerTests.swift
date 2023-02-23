//
//  MySingletonViewControllerTests.swift
//  HardDependenciesTests
//
//  Created by roberts.kursitis on 23/02/2023.
//

import XCTest
@testable import HardDependencies

final class MySingletonViewControllerTests: XCTestCase {
	
	override class func setUp() {
		super.setUp()
		MySingletonAnalytics.stubbedInstance = MySingletonAnalytics()
	}
	
	override class func tearDown() {
		MySingletonAnalytics.stubbedInstance = nil
		super.tearDown()
	}
	
	func test_viewDidAppear() {
		let sut = MySingletonViewController()
		sut.loadViewIfNeeded()
		sut.viewDidAppear(false)
		
		//Assert something
	}
	// As the log shows that "Not the MySingletonAnalytics singleton" was printed we replaced the singleton with a different one.
}
