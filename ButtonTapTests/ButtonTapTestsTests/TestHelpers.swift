//
//  TestHelpers.swift
//  ButtonTapTestsTests
//
//  Created by roberts.kursitis on 24/02/2023.
//

import UIKit

func tap(_ button: UIButton) {
	button.sendActions(for: .touchUpInside)
}
