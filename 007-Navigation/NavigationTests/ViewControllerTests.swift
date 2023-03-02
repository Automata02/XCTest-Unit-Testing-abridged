//
//  ViewControllerTests.swift
//  ViewControllerTests
//
//  Created by roberts.kursitis on 02/03/2023.
//

import XCTest
@testable import Navigation

final class ViewControllerTests: XCTestCase {
	func test_tappingCodePushButton_shouldPushCodeNextViewController() {
		let storyboard = UIStoryboard(name: "Main", bundle: nil)
		let sut: ViewController = storyboard.instantiateViewController(identifier: String(describing: ViewController.self))
		sut.loadViewIfNeeded()
		let navigation = UINavigationController(rootViewController: sut)
		tap(sut.codePushButton)
		
		executeRunLoop()
		//we're asking the runLoop to execute until Date() - current time.
		
		XCTAssertEqual(navigation.viewControllers.count, 2, "navigation stack")
		
		let pushedVC = navigation.viewControllers.last
//		XCTAssertTrue(pushedVC is CodeNextViewController, "Expected CodeNextViewController, " + "but was \(String(describing: pushedVC))")
		guard let codeNextVC = pushedVC as? CodeNextViewController else {
			XCTFail("Expected CodeNextViewController, " + "but was \(String(describing: pushedVC))")
			return
		}
		XCTAssertEqual(codeNextVC.label.text, "Push from code")
	}
}
