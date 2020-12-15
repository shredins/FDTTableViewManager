//
// Created by Tomasz Korab on 2019-03-23.
// Copyright (c) 2019 Tomasz Korab. All rights reserved.
//

import UIKit

open class TableViewCellItem<T: UITableViewCell>: TableViewCellItemProtocol {

    // MARK: - Properties
    public var shouldBeReloaded: Bool = false

    // MARK: - Weak Properties
    public weak var delegate: TableViewCellItemDelegate?

    // MARK: - Get-only Properties
    public let id = UUID().uuidString
    public let registerId = String(reflecting: T.self)
    
    open var shouldDeselectImmediately: Bool {
        return true
    }

    open var height: CGFloat {
        return UITableView.automaticDimension
    }

    open var loadedFromNib: Bool {
        return false
    }

    // MARK: - Inits
    public init() {}

    // MARK: - Public Instance Methods
    /// Empty method used to set layout of specified cell type. Should be overridden instead of using decorate(of cell:)
    open func setLayout(of cell: T) {}

    /// Calls method which decorates cell's layout
    public func decorate(_ cell: UITableViewCell) {
        if let cell = cell as? T {
            setLayout(of: cell)
        }
    }

}
