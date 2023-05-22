//
//  SpyURLSession.swift
//  NetworkResponseTests
//
//  Created by roberts.kursitis on 14/03/2023.
//

@testable import NetworkResponse
import Foundation

private class DummyURLSessionDataTask: URLSessionDataTask {
	override func resume() {
	}
}

class SpyURLSession: URLSessionProtocol {
	var dataTaskCallCount = 0
	var dataTaskArgsRequest: [URLRequest] = []
	var dataTaskArgsCompletionHandler: [(Data?, URLResponse?, Error?) -> Void] = []
	
	func dataTask(with request: URLRequest, completionHandler: @escaping @Sendable (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
		dataTaskCallCount += 1
		dataTaskArgsRequest.append(request)
		dataTaskArgsCompletionHandler.append(completionHandler)
		return DummyURLSessionDataTask()
	}
}
