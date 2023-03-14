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
	
	var handleResults: ([SearchResult]) -> Void = { print($0) }
	
	private(set) var results: [SearchResult] = [] {
		didSet {
//			print("Great success!")
			handleResults(results)
//			print(results.first)
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

