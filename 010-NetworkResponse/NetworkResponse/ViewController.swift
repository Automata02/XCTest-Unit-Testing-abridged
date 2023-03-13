//
//  ViewController.swift
//  NetworkRequest
//
//  Created by roberts.kursitis on 07/03/2023.
//

import UIKit

class ViewController: UIViewController {
	
	var session: URLSessionProtocol = URLSession.shared
	private var dataTask: URLSessionDataTask?
	
	private(set) var results: [SearchResult] = [] {
		didSet {
			print(results)
		}
	}
	
	@IBOutlet private(set) var button: UIButton!
	
	@IBAction private func buttonTapped() {
		searchForBook(terms: "out from boneville")
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view.
	}
	
	private func searchForBook(terms: String) {
		guard let encodedTerms = terms.addingPercentEncoding(
			withAllowedCharacters: .urlQueryAllowed),
			  let url = URL(string: "https://itunes.apple.com/search?" +
							"media=ebook&term=\(encodedTerms)") else { return }
		let request = URLRequest(url: url)
		
		dataTask = session.dataTask(with: request) { (data, response, error) in
			if error != nil {
				let errorMsg = error!.localizedDescription
				Task { await self.showError(errorMsg) }
			}
			
			guard let data = data else {
				return
				//not ideal for testing!
			}
			do {
				let decodedData = try JSONDecoder().decode(Search.self, from: data)
				Task { await self.setResult(decodedData.results) }
			} catch {
				let errorMsg = error.localizedDescription
				Task { await self.showError(errorMsg) }
			}
			Task {
				await self.invalidateDataTask()
			}
		}
		button.isEnabled = false
		dataTask?.resume()
	}
	
//	private func searchForBook(terms: String) {
//		guard let encodedTerms = terms.addingPercentEncoding(
//			withAllowedCharacters: .urlQueryAllowed),
//			  let url = URL(string: "https://itunes.apple.com/search?" +
//							"media=ebook&term=\(encodedTerms)") else { return }
//		let request = URLRequest(url: url)
//		dataTask = session.dataTask(with: request) {
//			[weak self] (data: Data?, response: URLResponse?, error: Error?)
//			-> Void in
//			guard let self = self else { return }
//
//			var decoded: Search?
//			var errorMessage: String?
//
//			if let error = error {
//				errorMessage = error.localizedDescription
//			} else if let response = response as? HTTPURLResponse, response.statusCode != 200 {
//				errorMessage = "Response: " + HTTPURLResponse.localizedString(forStatusCode: response.statusCode)
//			} else if let data = data {
//				do {
//					decoded = try JSONDecoder().decode(Search.self, from: data)
//				} catch {
//					errorMessage = error.localizedDescription
//				}
//			}
//
//			DispatchQueue.main.async { [weak self] in
//				guard let self = self else { return }
//				if let decoded = decoded {
//					self.results = decoded.results
//				}
//				if let errorMessage = errorMessage {
//					self.showError(errorMessage)
//				}
//				self.dataTask = nil
//				self.button.isEnabled = true
//			}
//		}
//		button.isEnabled = false
//		dataTask?.resume()
//	}
	
	private func setResult(_ results: [SearchResult]) {
		self.results = results
	}
	
	private func invalidateDataTask() {
		self.dataTask = nil
		self.button.isEnabled = true
	}
	
	private func showError(_ message: String) {
		let title = "Network problem"
		print("\(title): \(message)")
		
		let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
		let okAction = UIAlertAction(title: "OK", style: .default)
		alert.addAction(okAction)
		alert.preferredAction = okAction
		present(alert, animated: true)
	}
}

struct Search: Decodable {
	let results: [SearchResult]
}

struct SearchResult: Decodable, Equatable {
	let artistName: String
	let trackName: String
	let averageUserRating: Float
	let genres: [String]
}

extension URLSession: URLSessionProtocol {}

protocol URLSessionProtocol {
	func dataTask(
		with request: URLRequest,
		completionHandler: @escaping @Sendable (Data?, URLResponse?, Error?) -> Void ) -> URLSessionDataTask
}

