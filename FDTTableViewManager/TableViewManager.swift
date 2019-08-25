//
// Created by Tomasz Korab on 2019-03-23.
// Copyright (c) 2019 Tomasz Korab. All rights reserved.
//

import UIKit

public protocol TableViewManagerDelegate: class {

    /// Informs that specified item has been tapped
    func tableViewManager(_ manager: TableViewManager, didSelect item: TableViewCellItemProtocol)

}

public protocol TableViewManagerScrollViewDelegate: class {

    func tableViewManager(_ manager: TableViewManager, scrollViewDidScroll scrollView: UIScrollView)

}

public protocol TableViewManagerOwner: class {

    var manager: TableViewManager { get }

    func set(tableView: UITableView)

}

public extension TableViewManagerOwner {

    func set(tableView: UITableView) {
        manager.tableView = tableView
    }

}

public class TableViewManager: NSObject {

    // MARK: - Types
    public enum RowInsert {

        case append(item: TableViewCellItemProtocol)
        case insert(item: TableViewCellItemProtocol, indexPath: IndexPath)

    }

    public enum SectionInsert {

        case append(section: Section)
        case insert(section: Section, index: Int)

    }

    // MARK: - Weak Properties
    public weak var delegate: TableViewManagerDelegate?
    public weak var scrollViewDelegate: TableViewManagerScrollViewDelegate?

    // MARK: - Observed Properties
    public weak var tableView: UITableView? {
        didSet {
            setup()
        }
    }

    // MARK: - Private Properties
    private var sections: [Section] = []

    // MARK: - Public Instance Methods
    /// Returns item associated with the indexPath
    public func tableViewItem(for indexPath: IndexPath) -> TableViewCellItemProtocol {
        return sections[indexPath.section][indexPath.row]
    }

    public func reloadEverything(with sections: [Section]) {
        sections.forEach { section in
            section.rows.forEach {
                register(item: $0)
            }
        }

        self.sections = sections
        tableView?.reloadData()
    }

    public func reloadEverything(with items: [TableViewCellItemProtocol]) {
        items.forEach {
            register(item: $0)
        }

        let section = Section(rows: items)
        self.sections = [section]
        tableView?.reloadData()
    }

    public func reload(animation: UITableView.RowAnimation = .fade, items: [TableViewCellItemProtocol]) {
        guard let tableView = tableView else {
            fatalError("Trying to perform table operation before it being initialized")
        }

        var indexPaths: [IndexPath] = []

        for item in items {
            register(item: item)
            for (section, sectionModel) in sections.enumerated() {
                if let row = sectionModel.has(item: item) {
                    let newIndexPath = IndexPath(row: row, section: section)
                    indexPaths.append(newIndexPath)
                }
            }
        }

        if !indexPaths.isEmpty {
            tableView.reloadRows(at: indexPaths, with: animation)
        }
    }

    public func reload(animation: UITableView.RowAnimation = .fade, sections: [Section]) {
        guard let tableView = tableView else {
            fatalError("Trying to perform table operation before it being initialized")
        }

        let reloadedSectionsIds = sections.map {
            $0.id
        }

        var array: [Int] = []

        for (section, sectionModel) in self.sections.enumerated() {
            sectionModel.rows.forEach {
                register(item: $0)
            }

            if reloadedSectionsIds.contains(sectionModel.id) {
                array.append(section)
            }
        }

        if !array.isEmpty {
            let set = IndexSet(array)
            tableView.reloadSections(set, with: animation)
        }
    }

    public func add(animation: UITableView.RowAnimation = .fade, inserts: [RowInsert]) {
        guard let tableView = tableView else {
            fatalError("Trying to perform table operation before it being initialized")
        }

        var indexPaths: [IndexPath] = []
        var shouldInsertNewSection: Bool = false

        tableView.beginUpdates()

        inserts.forEach { insert in
            switch insert {
            case .append(let item):
                let indexPath: IndexPath

                if let lastSectionRowCount = sections.last?.rows.count {
                    let lastSection = sections.count - 1
                    indexPath = IndexPath(row: lastSectionRowCount, section: lastSection)
                    sections.last?.rows.append(item)
                } else {
                    let newSection = Section(rows: [item])
                    indexPath = IndexPath(row: 0, section: 0)
                    shouldInsertNewSection = true
                    sections = [newSection]
                }

                register(item: item)
                indexPaths.append(indexPath)
            case .insert(let item, let indexPath):
                sections[indexPath.section].rows.insert(item, at: indexPath.row)
                register(item: item)
                indexPaths.append(indexPath)
            }
        }

        if shouldInsertNewSection {
            let indexSet = IndexSet(integer: 0)
            tableView.insertSections(indexSet, with: animation)
        }

        tableView.insertRows(at: indexPaths, with: animation)
        tableView.endUpdates()
    }

    public func add(animation: UITableView.RowAnimation = .fade, inserts: [SectionInsert]) {
        guard let tableView = tableView else {
            fatalError("Trying to perform table operation before it being initialized")
        }

        var array: [Int] = []

        tableView.beginUpdates()

        inserts.forEach { insert in
            switch insert {
            case .append(let section):
                if !sections.isEmpty {
                    array.append(sections.count)
                    sections.append(section)
                } else {
                    sections = [section]
                    array.append(0)
                }

                section.rows.forEach {
                    register(item: $0)
                }
            case .insert(let sectionModel, let section):
                sections.insert(sectionModel, at: section)
                array.append(section)
                sectionModel.rows.forEach {
                    register(item: $0)
                }
            }
        }

        let indexSet = IndexSet(array)
        tableView.insertSections(indexSet, with: animation)
        tableView.endUpdates()
    }

    public func add(animation: UITableView.RowAnimation = .fade, items: [TableViewCellItemProtocol]) {
        let inserts: [RowInsert] = items.map {
            .append(item: $0)
        }
        add(animation: animation, inserts: inserts)
    }

    public func add(animation: UITableView.RowAnimation = .fade, sections: [Section]) {
        let inserts: [SectionInsert] = sections.map {
            .append(section: $0)
        }
        add(animation: animation, inserts: inserts)
    }

    public func delete(animation: UITableView.RowAnimation = .fade, items: [TableViewCellItemProtocol]) {
        guard let tableView = tableView else {
            fatalError("Trying to perform table operation before it being initialized")
        }

        var indexPaths: [IndexPath] = []
        var newSections: [Section] = sections

        tableView.beginUpdates()

        for item in items {
            if let indexPath = hasRowToRemove(matching: item, sectionsToUpdate: &newSections) {
                indexPaths.append(indexPath)
            }
        }

        var sectionsToRemove: [Int] = []

        tableView.deleteRows(at: indexPaths, with: animation)
        for indexPath in indexPaths.sorted(by: {$0.row > $1.row}) {
            newSections[indexPath.section].rows.remove(at: indexPath.row)
        }

        sections = newSections
            .enumerated()
            .filter { element in
                if element.1.isEmpty {
                    sectionsToRemove.append(element.0)
                    return false
                } else {
                    return true
                }
            }
            .map {
                $0.1
        }

        if !sectionsToRemove.isEmpty {
            let indexSet = IndexSet(sectionsToRemove)
            tableView.deleteSections(indexSet, with: animation)
        }

        tableView.endUpdates()
    }

    public func delete(animation: UITableView.RowAnimation = .fade, sections: [Section]) {
        guard let tableView = tableView else {
            fatalError("Trying to perform table operation before it being initialized")
        }

        var array: [Int] = []
        var newSections: [Section] = self.sections

        tableView.beginUpdates()

        for section in sections {
            if let index = hasSectionToRemove(matching: section, sectionsToUpdate: &newSections) {
                array.append(index)
            }
        }

        let indexSet = IndexSet(array)

        self.sections = newSections
        tableView.deleteSections(indexSet, with: animation)
        tableView.endUpdates()
    }

    // MARK: - Private Instance Methods
    /// Checks whether sections contains the row which is supposed to be removed
    private func hasRowToRemove(matching itemToRemove: TableViewCellItemProtocol, sectionsToUpdate: inout [Section]) -> IndexPath? {
        for (section, sectionModel) in sectionsToUpdate.enumerated() {
            if let row = sectionModel.has(item: itemToRemove) {
                return IndexPath(row: row, section: section)
            }
        }
        return nil
    }

    /// Checks whether sections contains the one which is supposed to be removed
    private func hasSectionToRemove(matching sectionToRemove: Section, sectionsToUpdate: inout [Section]) -> Int? {
        for (section, sectionModel) in sectionsToUpdate.enumerated() {
            if sectionToRemove == sectionModel || sectionModel.isEmpty {
                sectionsToUpdate.remove(at: section)
                return section
            }
        }
        return nil
    }

    /// Registers item's cell type
    private func register(item: TableViewCellItemProtocol) {
        guard let tableView = tableView else {
            fatalError("Trying to perform table operation before it being initialized")
        }

        if item.loadedFromNib {
            self.register(id: item.registerId)
        } else if let className = NSClassFromString(item.registerId) {
            tableView.register(className, forCellReuseIdentifier: item.registerId)
        }
    }

    /// Registers cells from xib files
    private func register(id: String) {
        if let className = NSClassFromString(id) {
            let bundle = Bundle(for: className)
            let nibName = id.components(separatedBy: ".")[1]
            let nib = UINib(nibName: nibName, bundle: bundle)
            self.tableView?.register(nib, forCellReuseIdentifier: id)
        }
    }

    /// Sets tableView's dataSource and delegate
    private func setup() {
        if let tableView = tableView {
            tableView.delegate = self
            tableView.dataSource = self
            tableView.reloadData()
        }
    }

}

// MARK: - UITableViewDataSource Methods
extension TableViewManager: UITableViewDataSource {

    public func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }

    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].count
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = tableViewItem(for: indexPath)
        let tableViewCell = tableView.dequeueReusableCell(withIdentifier: item.registerId, for: indexPath)

        item.delegate = self
        item.decorate(tableViewCell)

        return tableViewCell
    }

}

// MARK: - UITableViewDelegate Methods
extension TableViewManager: UITableViewDelegate {

    public func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableViewItem(for: indexPath).height
    }

    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableViewItem(for: indexPath).height
    }

    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = tableViewItem(for: indexPath)

        if item.shouldDeselectImmediately {
            tableView.deselectRow(at: indexPath, animated: true)
        }

        delegate?.tableViewManager(self, didSelect: item)
    }

    public func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        guard let item = tableViewItem(for: indexPath) as? TableViewCellItemInteractions else {
            return false
        }

        return item.canEdit
    }

    public func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        guard let item = tableViewItem(for: indexPath) as? TableViewCellItemInteractions else {
            return nil
        }

        return item.actions()
    }

    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        scrollViewDelegate?.tableViewManager(self, scrollViewDidScroll: scrollView)
    }

}

// MARK: - TableViewCellItemDelegate Methods
extension TableViewManager: TableViewCellItemDelegate {

    public func tableViewCellItemHasBeenSelected(_ item: TableViewCellItemProtocol) {
        delegate?.tableViewManager(self, didSelect: item)
    }

    public func tableViewCellItemWantsToReload(_ item: TableViewCellItemProtocol) {
        reload(items: [item])
    }

}
