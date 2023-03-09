//
//  MockURLSession.swift
//  NetworkRequestTests
//
//  Created by roberts.kursitis on 09/03/2023.
//

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
}

private class DummyURLSessionDataTask: URLSessionDataTask {
	override func resume() {
	}
}
