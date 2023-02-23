//
//  OverrideViewControllerTests.swift
//  HardDependenciesTests
//
//  Created by roberts.kursitis on 23/02/2023.
//

import XCTest
@testable import HardDependencies

//Overrides analytics method to provide a different instance of Analytics.
class TestableOverrideViewController: OverrideViewController {
	override func analytics() -> Analytics {
		Analytics()
	}
}
/*
 Subclass and Override method can only be applied to classes that permit subclassing.
 Can’t do it on structs, with FINAL classes nor storyboard-based view controllers.
 This method is great for overcoming problematic methods with minimal changes to production code.
*/

class OverrideViewControllerTests: XCTestCase {
	func test_viewDidAppear() {
		let sut = TestableOverrideViewController()
		sut.loadViewIfNeeded()
		sut.viewDidAppear(false)
		
		//some testing
	}
}
