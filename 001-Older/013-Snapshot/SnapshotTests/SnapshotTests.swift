//
//  SnapshotTests.swift
//  SnapshotTests
//
//  Created by roberts.kursitis on 23/03/2023.
//
#warning("As Snapshots are slow it's better to seperate them from Unit tests. Ideally in seperate test suites.")

import iOSSnapshotTestCase
@testable import Snapshot

final class SnapshotTests: FBSnapshotTestCase {
	var sut: ViewController!
	
	override func setUp() {
		super.setUp()
		recordMode = false
		let sb = UIStoryboard(name: "Main", bundle: nil)
		sut = sb.instantiateViewController(identifier: String(describing: ViewController.self))
		sut.loadViewIfNeeded()
	}
	
	override func tearDown() {
		sut = nil
		super.tearDown()
	}
	
	func test_example() {
		FBSnapshotVerifyViewController(sut)
	}
}
