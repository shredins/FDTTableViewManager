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

    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    public static func ==(lhs: Section, rhs: Section) -> Bool {
        return lhs.id == rhs.id
    }

}

public extension Section {

    func addSection(_ build: () -> [TableViewCellItemProtocol]) -> [Section] {
        let newSection = Section(rows: build())
        return [self, newSection]
    }

    func addSection(_ items: TableViewCellItemProtocol...) -> [Section] {
        return addSection {
            return items
        }
    }

    static func buildSection(_ build: () -> [TableViewCellItemProtocol]) -> Section {
        return Section(rows: build())
    }

    static func buildSection(_ items: TableViewCellItemProtocol...) -> Section {
        return buildSection {
            return items
        }
    }

}

public extension Sequence where Element: Section {

    func addSection(_ build: () -> [TableViewCellItemProtocol]) -> [Section] {
        guard var array = self as? [Section] else {
            fatalError("Couldn't build section sequence")
        }
        let newSection = Section(rows: build())
        array.append(newSection)
        return array
    }

    func addSection(_ items: TableViewCellItemProtocol...) -> [Section] {
        return addSection {
            return items
        }
    }


}
