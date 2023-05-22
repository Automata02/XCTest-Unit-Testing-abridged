//
//  MockURLSession.swift
//  NetworkRequestTests
//
//  Created by roberts.kursitis on 09/03/2023.
//
import XCTest
import Foundation
@testable import NetworkRequest

class MockURLSession: URLSessionProtocol {
	var dataTaskCallCount = 0
	var dataTaskArgsRequest: [URLRequest] = []
	
	func dataTask(
		with request: URLRequest,
		completionHandler: @escaping @Sendable (Data?, URLResponse?, Error?) -> Void
		) -> URLSessionDataTask {
			dataTaskCallCount += 1
			dataTaskArgsRequest.append(request)
			return DummyURLSessionDataTask()
	}
	
	func verifyDataTask(with request: URLRequest, file: StaticString = #file, line: UInt = #line) {
		guard dataTaskWasCalledOnce(file: file, line: line) else { return }
		XCTAssertEqual(dataTaskArgsRequest.first, request, "request", file: file, line: line)
	}
	
	private func dataTaskWasCalledOnce(file: StaticString = #file, line: UInt = #line) -> Bool {
		verifyMethoCalledOnce(methodName: "dataTask(widthLcompletionHandler:)",
							  callCount: dataTaskCallCount,
							  describeArgs: "erquest: \(dataTaskArgsRequest)",
							  file: file,
							  line: line)
	}
}

func verifyMethoCalledOnce(methodName: String, callCount: Int, describeArgs: @autoclosure () -> String, file: StaticString = #file, line: UInt = #line) -> Bool {
	if callCount == 0 {
		XCTFail("Wanted but not invoked: \(methodName)", file: file, line: line)
		return false
	}
	if callCount > 1 {
		XCTFail("Wanted 1 time but was called \(callCount) times." + "\(methodName) with \(describeArgs())", file: file, line: line)
		return false
	}
	return true
}

private class DummyURLSessionDataTask: URLSessionDataTask {
	override func resume() {
	}
}
