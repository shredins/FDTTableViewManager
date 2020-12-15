//
//  ExampleCellItem.swift
//  FDTTableViewManagerExample
//
//  Created by Tomasz Korab on 31/03/2019.
//  Copyright © 2019 Tomasz Korab. All rights reserved.
//

import Foundation

class ExampleCellItem: TableViewCellItem<ExampleTableViewCell> {
    
    // MARK: - Properties
    let text: String
    
    // MARK: - Inits
    init(text: String) {
        self.text = text
    }
    
    // MARK: - Overridden Methods
    override func setLayout(of cell: ExampleTableViewCell) {
        cell.label.text = text
    }
    
}
