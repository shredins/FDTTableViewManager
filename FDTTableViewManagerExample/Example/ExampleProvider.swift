//
//  ExampleProvider.swift
//  FDTTableViewManagerExample
//
//  Created by Tomasz Korab on 31/03/2019.
//  Copyright © 2019 Tomasz Korab. All rights reserved.
//

import UIKit

class ExampleProvider {
    
    // MARK: - Properties
    private let tableViewManager: TableViewManager
    
    // MARK - Inits
    init(tableViewManager: TableViewManager? = nil) {
        self.tableViewManager = tableViewManager ?? TableViewManager()
    }
    
    // MARK: - Public Instance Methods
    /// Sets tableViewManager's tableView
    func setupTableViewManager(tableView: UITableView) {
        tableViewManager.tableView = tableView
    }
    
    /// Loads data to the tableView
    func load() {
        let sections = Section
            .buildSection {
                (0...10)
                    .map {
                        ExampleCellItem(text: "Text \($0)")
                }
            }
            .addSection {
                [
                    ExampleCellItem(text: "Section 1 Starts Here")
                ]
            }
            .addSection(
                ExampleCellItem(text: "Row 0 of Section 1"),
                ExampleCellItem(text: "Row 1 of Section 1"),
                ExampleCellItem(text: "The End Of Section 1")
            )
        
        tableViewManager.reloadEverything(with: sections)
    }
    
}
