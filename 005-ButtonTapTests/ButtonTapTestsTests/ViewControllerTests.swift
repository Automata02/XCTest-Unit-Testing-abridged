//
//  ViewControllerTests.swift
//  ButtonTapTestsTests
//
//  Created by roberts.kursitis on 24/02/2023.
//

import XCTest
@testable import ButtonTapTests

final class ViewControllerTests: XCTestCase {
	func test_tappingButton() {
		let storyboard = UIStoryboard(name: "Main", bundle: nil)
		let sut: ViewController = storyboard.instantiateViewController(identifier: String(describing: ViewController.self))
		sut.loadViewIfNeeded()
		//with button access control set to private(set) we can call use the button.
		tap(sut.button)
	}
}












