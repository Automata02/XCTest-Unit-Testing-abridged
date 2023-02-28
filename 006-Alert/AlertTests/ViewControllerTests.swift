//
//  ViewControllerTests.swift
//  ViewControllerTests
//
//  Created by roberts.kursitis on 28/02/2023.
//

import XCTest
import ViewControllerPresentationSpy
@testable import Alert

final class ViewControllerTests: XCTestCase {
	private var alertVerifier: AlertVerifier!
	private var sut: ViewController!
	
	@MainActor override func setUp() {
		super.setUp()
		alertVerifier = AlertVerifier()
		let storyboard = UIStoryboard(name: "Main", bundle: nil)
		sut = storyboard.instantiateViewController(identifier: String(describing: ViewController.self))
		sut.loadViewIfNeeded()
	}
	
	override func tearDown() {
		alertVerifier = nil
		sut = nil
		super.tearDown()
	}
	
	
	@MainActor func test_tappingButton_shouldShowAlert() {
		tap(sut.button)
		
		alertVerifier.verify(title: "Do the Thing?",
							 message: "Let us know if you want to do this thing.",
							 animated: true,
							 actions: [
								.cancel("Cancel"),
								.default("OK"),
							 ],
							 presentingViewController: sut
		)
		XCTAssertEqual(alertVerifier.preferredAction?.title, "OK", "preferred action")
	}
	
	@MainActor func test_exectureAlertAction_withOKButton() throws {
		tap(sut.button)
		
		try alertVerifier.executeAction(forButton: "OK")
		
		//assert something
	}
}
