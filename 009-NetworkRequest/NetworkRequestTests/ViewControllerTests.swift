//
//  NetworkRequestTests.swift
//  NetworkRequestTests
//
//  Created by roberts.kursitis on 07/03/2023.
//

import XCTest
@testable import NetworkRequest

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
	
	func test_tappingButton_shouldMakeDataTaskToSearchForEBookOutFromBoneville() {
		let mockURLSession = MockURLSession()
		sut.session = mockURLSession
		sut.loadViewIfNeeded()
		
		tap(sut.button)
		
//		XCTAssertEqual(mockURLSession.dataTaskCallCount, 1, "call count")
//
//		XCTAssertEqual(mockURLSession.dataTaskArgsRequest.first, URLRequest(
//			url: URL(string: "https://itunes.apple.com/search?" +
//			"media=ebook&term=out%20from%20boneville")!), "request")
		mockURLSession.verifyDataTask(with: URLRequest(url: URL(string: "https://itunes.apple.com/search?" +
																		"media=ebook&term=out%20from%20boneville")!))
	}
}
