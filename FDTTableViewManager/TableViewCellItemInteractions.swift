//
//  TableViewCellItemInteractions.swift
//  TableViewManager
//
//  Created by Tomasz Korab on 29/03/2019.
//  Copyright © 2019 Tomasz Korab. All rights reserved.
//

import UIKit

public protocol TableViewCellItemInteractions: class {

    var canEdit: Bool { get }
    
    func actions() -> [UITableViewRowAction]

}
