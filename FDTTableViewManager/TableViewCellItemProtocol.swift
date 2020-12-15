//
// Created by Tomasz Korab on 2019-03-23.
// Copyright (c) 2019 Tomasz Korab. All rights reserved.
//

import UIKit

public protocol TableViewCellItemDelegate: class {

    /// Used to inform TableViewManager that item has been selected. It will call default selection method
    func tableViewCellItemHasBeenSelected(_ item: TableViewCellItemProtocol)

    /// Used to inform that TableViewManager should reload item
    func tableViewCellItemWantsToReload(_ item: TableViewCellItemProtocol)

}

public protocol TableViewCellItemProtocol: class {

    // MARK: - Properties
    var id: String { get }
    var registerId: String { get }
    var height: CGFloat { get }
    var loadedFromNib: Bool { get }
    var shouldDeselectImmediately: Bool { get }
    var delegate: TableViewCellItemDelegate? { get set }

    // MARK: - Public Instance Methods
    func decorate(_ cell: UITableViewCell)

}
