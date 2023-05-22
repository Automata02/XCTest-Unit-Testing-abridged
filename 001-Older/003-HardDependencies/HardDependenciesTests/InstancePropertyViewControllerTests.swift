//
//  InstancePropertyViewControllerTests.swift
//  HardDependenciesTests
//
//  Created by roberts.kursitis on 24/02/2023.
//

import XCTest
@testable import HardDependencies

final class InstancePropertyViewControllerTests: XCTestCase {
	func test_viewDidAppear() {
		let storyboard = UIStoryboard(name: "Main", bundle: nil)
		let sut: InstancePropertyViewController = storyboard.instantiateViewController(identifier: String(describing: InstancePropertyViewController.self))
		sut.analytics = Analytics()
		sut.loadViewIfNeeded()
		sut.viewDidAppear(false)
		//assert something
	}
}
