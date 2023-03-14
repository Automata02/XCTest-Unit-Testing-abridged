//
//  NetworkRequestTests.swift
//  NetworkRequestTests
//
//  Created by roberts.kursitis on 07/03/2023.
//

import XCTest
import ViewControllerPresentationSpy
@testable import NetworkResponse

final class ViewControllerTests: XCTestCase {
	private var sut: ViewController!
	private var spyURLSession: SpyURLSession!
	private var alertVerifier: AlertVerifier!
	
	@MainActor override func setUp() {
		super.setUp()
		alertVerifier = AlertVerifier()
		
		let storyboard = UIStoryboard(name: "Main", bundle: nil)
		sut = storyboard.instantiateViewController(identifier: String(describing: ViewController.self))
		
		spyURLSession = SpyURLSession()
		sut.session = spyURLSession
		
		sut.loadViewIfNeeded()
	}
	
	override func tearDown() {
		sut = nil
		spyURLSession = nil
		alertVerifier = nil
		super.tearDown()
	}
	
	//MARK: Unit Tests
	
	func test_searchForBookNetworkCall_withSuccessResponse_shouldSaveDataInResults() {
		let handleResultCalled = expectation(description: "handleResults called")
		sut.handleResults = { _ in
			handleResultCalled.fulfill()
		}
		tap(sut.button)
		
		spyURLSession.dataTaskArgsCompletionHandler.first?(jsonData(), response(statusCode: 200), nil)
		
		waitForExpectations(timeout: 0.01)
		
		XCTAssertEqual(sut.results, [SearchResult(artistName: "Artist", trackName: "Track", averageUserRating: 2.5, genres: ["Foo", "Bar"])])
		//Test captures the arguments we want to test, calling fulfill() escapes the wait condition used in async method.
	}
	
	func test_searchForBookNetworkCall_withSuccessResponse_shouldNotSaveDataInResults() {
		tap(sut.button)
		
		spyURLSession.dataTaskArgsCompletionHandler.first?(jsonData(), response(statusCode: 200), nil)
		
		XCTAssertEqual(sut.results, [])
		//Test skips async closure, shows that without it results aren't saved.
	}
	
	@MainActor func test_searchForBookNetworkCall_withError_shouldShowAlert() {
		tap(sut.button)
		let alertShown = expectation(description: "alert shown")
		alertVerifier.testCompletion = {
			alertShown.fulfill()
		}
		
		spyURLSession.dataTaskArgsCompletionHandler.first?(nil, nil, TestError(message: "oh no"))
		waitForExpectations(timeout: 0.01)
		verifyErrorAlert(message: "oh no")
	}
	
	@MainActor func test_searchForBookNetworkCall_withErrorPreAsync_shouldNotShowAlert() {
		tap(sut.button)
		
		spyURLSession.dataTaskArgsCompletionHandler.first?(nil, nil, TestError(message: "DUMMY"))
		
		XCTAssertEqual(alertVerifier.presentedCount, 0)
	}
	
	//MARK: Helper functions
	
	@MainActor private func verifyErrorAlert(message: String, file: StaticString = #file, line: UInt = #line) {
		alertVerifier.verify(title: "Network problem", message: message, animated: true, actions: [.default("OK")], presentingViewController: sut, file: file, line: line)
		XCTAssertEqual(alertVerifier.preferredAction?.title, "OK", "preferred action", file: file, line: line)
	}
	
	
	private func response(statusCode: Int) -> HTTPURLResponse? {
		HTTPURLResponse(url: URL(string: "http://DUMMY")!, statusCode: statusCode, httpVersion: nil, headerFields: nil)
	}
	
	private func jsonData() -> Data {
		"""
		{
			"results": [
				{
					"artistName": "Artist",
					"trackName": "Track",
					"averageUserRating": 2.5,
					"genres": [
						"Foo",
						"Bar"
					]
				}
			]
		}
		""".data(using: .utf8)!
	}
}
