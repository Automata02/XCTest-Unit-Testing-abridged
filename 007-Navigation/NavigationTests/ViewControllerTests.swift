//
//  ViewControllerTests.swift
//  ViewControllerTests
//
//  Created by roberts.kursitis on 02/03/2023.
//

import XCTest
import ViewControllerPresentationSpy
@testable import Navigation

final class ViewControllerTests: XCTestCase {
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
	
	
	func test_tappingCodePushButton_shouldPushCodeNextViewController() {
		let navigation = UINavigationController(rootViewController: sut)
		tap(sut.codePushButton)
		
		executeRunLoop()
		//we're asking the runLoop to execute until Date() - current time.
		
		XCTAssertEqual(navigation.viewControllers.count, 2, "navigation stack")
		
		let pushedVC = navigation.viewControllers.last
		guard let codeNextVC = pushedVC as? CodeNextViewController else {
			XCTFail("Expected CodeNextViewController, " + "but was \(String(describing: pushedVC))")
			return
		}
		XCTAssertEqual(codeNextVC.label.text, "Push from code")
	}
	
	@MainActor func test_tappingCodeModalButton_shouldPresentCodeNextViewController() {
		let presentationVerifier = PresentationVerifier()
		tap(sut.codeModalButton)

		let codeNextVC: CodeNextViewController? = presentationVerifier.verify(animated: true, presentingViewController: sut)
		XCTAssertEqual(codeNextVC?.label.text, "Modal from code")
	}
}
