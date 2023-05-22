//
//  InstanceInitializerViewControllerTests.swift
//  HardDependenciesTests
//
//  Created by roberts.kursitis on 24/02/2023.
//

import XCTest
@testable import HardDependencies

final class InstanceInitializerViewControllerTests: XCTestCase {
	
	func test_viewDidAppear() {
		let sut = InstanceInitializerViewController(analytics: Analytics())
		sut.loadViewIfNeeded()
		sut.viewDidAppear(false)
		//assert something
	}
}
