//
//  ClosureInitializerViewControllerTests.swift
//  HardDependenciesTests
//
//  Created by roberts.kursitis on 24/02/2023.
//

import XCTest
@testable import HardDependencies

final class ClosureInitializerViewControllerTests: XCTestCase {
	func test_viewDidAppear() {
		let sut = ClosureInitializerViewController { Analytics() }
		sut.loadViewIfNeeded()
		sut.viewDidAppear(false)
		//assert something
	}
}
