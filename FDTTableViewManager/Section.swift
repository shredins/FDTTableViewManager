//
// Created by Tomasz Korab on 2019-03-23.
// Copyright (c) 2019 Tomasz Korab. All rights reserved.
//

import Foundation

public class Section {

    // MARK: - Properties
    let id: String = UUID().uuidString
    
    // MARK: - Public Properties
    public var rows: [TableViewCellItemProtocol]

    // MARK: - Get-only Properties
    public var count: Int {
        return rows.count
    }

    public var isEmpty: Bool {
        return count == 0
    }

    // MARK: - Subscript
    public subscript(index: Int) -> TableViewCellItemProtocol {
        get {
            return rows[index]
        }
        set {
            rows[index] = newValue
        }
    }

    // MARK: - Inits
    public init(rows: [TableViewCellItemProtocol] = []) {
        self.rows = rows
    }

    // MARK: - Public Instance Methods
    /// Returns index whether item is in this section
    public func has(item: TableViewCellItemProtocol) -> Int? {
        return rows.firstIndex(where: { $0.id == item.id })
    }

}

extension Section: Hashable {

    public var hashValue: Int {
        return id.hashValue
    }

    public static func ==(lhs: Section, rhs: Section) -> Bool {
        return lhs.id == rhs.id
    }

}
