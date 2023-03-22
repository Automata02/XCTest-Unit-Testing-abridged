//
//  testHelpers.swift
//  TableViewTests
//
//  Created by roberts.kursitis on 22/03/2023.
//

import UIKit

func didSelectRow(in tableView: UITableView, row: Int, section: Int = 0) {
	tableView.delegate?.tableView?(tableView, didSelectRowAt: IndexPath(row: row, section: section))
}

func numberOfRows(in tableView: UITableView, section: Int = 0) -> Int? {
	tableView.dataSource?.tableView(tableView, numberOfRowsInSection: section)
}

func cellForRow(in tableView: UITableView, row: Int, section: Int = 0) -> UITableViewCell? {
	tableView.dataSource?.tableView(tableView, cellForRowAt: IndexPath(row: row, section: section))
}
