//
//  File.swift
//  NavigationTests
//
//  Created by roberts.kursitis on 02/03/2023.
//

import UIKit

func tap(_ button: UIButton) {
	button.sendActions(for: .touchUpInside)
}

func executeRunLoop() {
	RunLoop.current.run(until: Date())
}
