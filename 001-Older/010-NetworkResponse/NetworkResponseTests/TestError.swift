//
//  TestError.swift
//  NetworkResponseTests
//
//  Created by roberts.kursitis on 14/03/2023.
//

import Foundation

struct TestError: LocalizedError {
	let message: String
	
	var errorDescription: String? { message }
}
