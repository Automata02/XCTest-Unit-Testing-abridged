//
//  FakeUserDefaults.swift
//  ViewControllerTests
//
//  Created by roberts.kursitis on 06/03/2023.
//

import Foundation
@testable import UserDefaultsTests

class FakeUserDefaults: UserDefaultsProtocol {
	var integers: [String: Int] = [:]
	
	func set(_ value: Int, forKey defaultName: String) {
		integers[defaultName] = value
	}
	
	func integer(forKey defaultName: String) -> Int {
		integers[defaultName] ?? 0
	}
	
}
