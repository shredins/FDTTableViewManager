//
//  ExampleTableViewController.swift
//  FDTTableViewManagerExample
//
//  Created by Tomasz Korab on 31/03/2019.
//  Copyright © 2019 Tomasz Korab. All rights reserved.
//

import UIKit

class ExampleTableViewController: UITableViewController {
    
    // MARK: - Private Properties
    private let provider: ExampleProvider
    
    // MARK: - Inits
    init(provider: ExampleProvider? = nil) {
        self.provider = provider ?? ExampleProvider()
        super.init(style: .plain)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }

    // MARK: - Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        provider.setupTableViewManager(tableView: tableView)
        provider.load()
    }

}
