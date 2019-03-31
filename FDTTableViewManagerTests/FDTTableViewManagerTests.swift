//
//  FDTTableViewManagerTests.swift
//  TableViewManager
//
//  Created by Tomasz Korab on 2019-03-30.
//  Copyright © 2019 Tomasz Korab. All rights reserved.
//

import UIKit
import XCTest

@testable
import FDTTableViewManager

class TableViewManagerTests: XCTestCase {

    var tableViewManager: TableViewManager!
    fileprivate var tableView: TestTableView!

    override func setUp() {
        tableViewManager = TableViewManager()
        tableView = TestTableView()
        tableView.frame = UIScreen.main.bounds
        tableView.layoutIfNeeded()
        tableViewManager.tableView = tableView
    }

    override func tearDown() {
        tableViewManager = nil
        tableView = nil
    }

    func testDataSourceSetup() {
        XCTAssertTrue(tableView.dataSource === tableViewManager, "Should have tableView's dataSource equal to tableViewManager")
    }

    func testDelegateSetup() {
        XCTAssertTrue(tableView.delegate === tableViewManager, "Should have tableView's delegate equal to tableViewManager")
    }

    func testReloadDataCall() {
        XCTAssertTrue(tableView.didCallReloadData, "Should reload all data when tableViewManager's setup() called")
    }

    func testRegisterCellCall() {
        tableViewManager.add(animation: .none,
                             items: [
                                 TestTableViewCellItem(text: "")
                             ])

        XCTAssertTrue(tableView.didCallRegisterCell, "Should register cell of item when item is added")
    }

    func testAppendingSingleSection() {
        let newSection = (0...3)
                .map {
                    TestTableViewCellItem(text: "Text \($0)")
                }
                .buildSection()

        tableViewManager.add(animation: .none, sections: [newSection])
        XCTAssertEqual(tableView.numberOfSections, 1, "Should have 1 section")
        XCTAssertEqual(tableView.numberOfRows(inSection: 0), 4, "Should have 4 rows")
    }

    func testAppendingMultipleSection() {
        let newSection = (0...3)
                .map {
                    TestTableViewCellItem(text: "Text \($0)")
                }
                .buildSection()

        let secondNewSection = (0...1)
                .map {
                    TestTableViewCellItem(text: "Text \($0)")
                }
                .buildSection()

        tableViewManager.add(animation: .none, sections: [newSection, secondNewSection])
        XCTAssertEqual(tableView?.numberOfSections, 2, "Should have 2 section")
        XCTAssertEqual(tableView?.numberOfRows(inSection: 0), 4, "Should have 4 rows in section 0")
        XCTAssertEqual(tableView?.numberOfRows(inSection: 1), 2, "Should have 2 rows in section 1")
    }

    func testAppendingItems() {
        let newItems = (0...3)
                .map {
            TestTableViewCellItem(text: "Text \($0)")
        }

        tableViewManager.add(animation: .none, items: newItems)
        XCTAssertEqual(tableView?.numberOfSections, 1, "Should have 1 section")
        XCTAssertEqual(tableView?.numberOfRows(inSection: 0), 4, "Should have 4 rows")
    }

    func testItemsDifferentOperationsOnEmptySections() {
        tableViewManager.add(animation: .none,
                             inserts: [
                                 .append(item: TestTableViewCellItem(text: "0")),
                                 .insert(item: TestTableViewCellItem(text: "1"),
                                         indexPath: IndexPath(row: 1,
                                                              section: 0)),
                                 .insert(item: TestTableViewCellItem(text: "2"),
                                         indexPath: IndexPath(row: 2,
                                                              section: 0))
                             ])
        XCTAssertEqual(tableView?.numberOfSections, 1, "Should have 1 section")
        XCTAssertEqual(tableView?.numberOfRows(inSection: 0), 3, "Should have 3 rows")
    }

    func testItemsDifferentOperationsOnNonEmptySections() {
        testItemsDifferentOperationsOnEmptySections()

        tableViewManager.add(animation: .none,
                             inserts: [
                                 .insert(item: TestTableViewCellItem(text: "4"),
                                         indexPath: IndexPath(row: 1,
                                                              section: 0)),
                                 .insert(item: TestTableViewCellItem(text: "5"),
                                         indexPath: IndexPath(row: 2,
                                                              section: 0)),
                                 .append(item: TestTableViewCellItem(text: "3"))
                             ])
        XCTAssertEqual(tableView?.numberOfSections, 1, "Should have 1 section")
        XCTAssertEqual(tableView?.numberOfRows(inSection: 0), 6, "Should have 6 rows")

        let expectedNames = ["0", "4", "5", "1", "2", "3"]

        for row in 0...5 {
            let indexPath = IndexPath(row: row, section: 0)
            let item = tableViewManager.tableViewItem(for: indexPath) as! TestTableViewCellItem
            let expectedName = expectedNames[row]
            XCTAssertEqual(item.text, expectedName, "Should have \(expectedName) name")
        }
    }

    func testSectionsDifferentOperations() {
        tableViewManager.add(animation: .none,
                             inserts: [
                                 .append(section: Section()),
                                 .insert(section: Section(), index: 1),
                                 .append(section: Section(rows: [
                                     TestTableViewCellItem(text: "0")
                                 ]))
                             ])
        XCTAssertEqual(tableView?.numberOfSections, 3, "Should have 3 section")
        XCTAssertEqual(tableView?.numberOfRows(inSection: 0), 0, "Should have 0 rows in section 0")
        XCTAssertEqual(tableView?.numberOfRows(inSection: 1), 0, "Should have 0 rows in section 1")
        XCTAssertEqual(tableView?.numberOfRows(inSection: 2), 1, "Should have 1 rows in section 2")
    }

    func testItemsReloading() {
        let indexPath1 = IndexPath(row: 0, section: 0)
        let indexPath2 = IndexPath(row: 1, section: 0)
        let indexPath3 = IndexPath(row: 2, section: 0)

        let item1 = TestTableViewCellItem(text: "1")
        let item2 = TestTableViewCellItem(text: "2")
        let item3 = TestTableViewCellItem(text: "3")

        tableViewManager.add(animation: .none,
                             items: [item1, item2, item3])

        XCTAssertEqual(tableView?.numberOfSections, 1, "Should have 1 section")
        XCTAssertEqual(tableView?.numberOfRows(inSection: 0), 3, "Should have 3 rows in section 0")

        let cell1 = tableView?.cellForRow(at: indexPath1) as! TestTableViewCell
        let cell2 = tableView?.cellForRow(at: indexPath2) as! TestTableViewCell
        let cell3 = tableView?.cellForRow(at: indexPath3) as! TestTableViewCell

        XCTAssertEqual(cell1.label.text!, "1", "Should have label's text equal to '1'")
        XCTAssertEqual(cell2.label.text!, "2", "Should have label's text equal to '2'")
        XCTAssertEqual(cell3.label.text!, "3", "Should have label's text equal to '3'")

        item1.text = "Reloaded 1"
        item3.text = "Reloaded 3"

        tableViewManager.reload(animation: .none,
                                items: [item1, item3])

        let rCell1 = tableView?.cellForRow(at: indexPath1) as! TestTableViewCell
        let rCell2 = tableView?.cellForRow(at: indexPath2) as! TestTableViewCell
        let rCell3 = tableView?.cellForRow(at: indexPath3) as! TestTableViewCell

        XCTAssertEqual(rCell1.label.text!, "Reloaded 1", "Should have label's text equal to 'Reloaded 1'")
        XCTAssertEqual(rCell2.label.text!, "2", "Should have label's text equal to '2'")
        XCTAssertEqual(rCell3.label.text!, "Reloaded 3", "Should have label's text equal to 'Reloaded 3'")
    }

    func testSectionsReload() {
        let section = Section()

        tableViewManager.add(animation: .none, sections: [section])

        XCTAssertEqual(tableView?.numberOfSections, 1, "Should have 1 section")
        XCTAssertEqual(tableView?.numberOfRows(inSection: 0), 0, "Should have 0 rows in section 0")

        section.rows = [
            TestTableViewCellItem(text: "Text")
        ]

        tableViewManager.reload(animation: .none, sections: [section])

        XCTAssertEqual(tableView?.numberOfSections, 1, "Should have 1 section")
        XCTAssertEqual(tableView?.numberOfRows(inSection: 0), 1, "Should have 1 rows in section 0")
    }

    func testItemsDeletion() {
        let item = TestTableViewCellItem(text: "Text")

        tableViewManager.add(animation: .none,
                             sections: [
                                 Section(),
                                 Section(rows: [
                                     item
                                 ])
                             ])

        XCTAssertEqual(tableView?.numberOfSections, 2, "Should have 2 section")
        XCTAssertEqual(tableView?.numberOfRows(inSection: 0), 0, "Should have 0 rows in section 0")
        XCTAssertEqual(tableView?.numberOfRows(inSection: 1), 1, "Should have 1 rows in section 1")

        tableViewManager.delete(animation: .none, items: [item])

        XCTAssertEqual(tableView?.numberOfSections, 0, "Should have 0 section")
    }

    func testSectionsDeletion() {
        let section = Section()
        tableViewManager.add(animation: .none,
                             sections: [
                                 section,
                                 Section(rows: [
                                     TestTableViewCellItem(text: "Text")
                                 ])
                             ])

        XCTAssertEqual(tableView?.numberOfSections, 2, "Should have 2 section")
        XCTAssertEqual(tableView?.numberOfRows(inSection: 0), 0, "Should have 0 rows in section 0")
        XCTAssertEqual(tableView?.numberOfRows(inSection: 1), 1, "Should have 1 rows in section 1")

        tableViewManager.delete(animation: .none, sections: [section])

        XCTAssertEqual(tableView?.numberOfSections, 1, "Should have 1 section")
        XCTAssertEqual(tableView?.numberOfRows(inSection: 0), 1, "Should have 1 rows in section 0")
    }

    func testItemInternalSelectionCall() {
        let indexPath = IndexPath(row: 0, section: 0)
        let delegate = TestTableViewManagerDelegate()

        tableViewManager.delegate = delegate

        let item = TestTableViewCellItem(text: "")
        tableViewManager?.add(animation: .none,
                              items: [item])

        XCTAssertEqual(tableView?.numberOfSections, 1, "Should have 1 section")
        XCTAssertEqual(tableView?.numberOfRows(inSection: 0), 1, "Should have 1 rows")

        let cell = tableView?.cellForRow(at: indexPath) as! TestTableViewCell
        cell.button.sendActions(for: .touchUpInside)

        let selectedItem = delegate.selectedItem as! TestTableViewCellItem
        XCTAssertEqual(selectedItem.id, item.id, "Should be the same item")
    }

    func testItemInternalReloadCall() {
        let item = TestTableViewCellItem(text: "")
        let indexPath = IndexPath(row: 0, section: 0)

        tableViewManager?.add(animation: .none,
                              items: [item])

        XCTAssertEqual(tableView?.numberOfSections, 1, "Should have 1 section")
        XCTAssertEqual(tableView?.numberOfRows(inSection: 0), 1, "Should have 1 rows")

        let cellBeforeReload = tableView?.cellForRow(at: indexPath) as! TestTableViewCell
        XCTAssertEqual(cellBeforeReload.label.text!, "", "Should have empty text")

        item.reload()

        let cellAfterReload = tableView?.cellForRow(at: indexPath) as! TestTableViewCell
        XCTAssertEqual(cellAfterReload.label.text!, "Reloaded", "Should have text equal to 'Reloaded'")
    }

}

// MARK: - Mock Types
private class TestTableViewManagerDelegate: TableViewManagerDelegate {

    var selectedItem: TableViewCellItemProtocol?
    func tableViewManager(_ manager: TableViewManager, didSelect item: TableViewCellItemProtocol) {
        selectedItem = item
    }

}

private class TestTableViewCellItem: TableViewCellItem<TestTableViewCell> {

    var text: String

    override var height: CGFloat {
        return 1
    }

    init(text: String) {
        self.text = text
    }

    override func setLayout(of cell: TestTableViewCell) {
        cell.label.text = text
        cell.button.addTarget(self, action: #selector(buttonHasBeenTapped), for: .touchUpInside)
    }

    func reload() {
        text = "Reloaded"
        delegate?.tableViewCellItemWantsToReload(self)
    }

    @objc private func buttonHasBeenTapped() {
        delegate?.tableViewCellItemHasBeenSelected(self)
    }

}

private class TestTableView: UITableView {

    var didCallReloadData = false
    override func reloadData() {
        super.reloadData()
        didCallReloadData = true
    }

    var didCallRegisterCell = false
    override func register(_ cellClass: AnyClass?, forCellReuseIdentifier identifier: String) {
        super.register(cellClass, forCellReuseIdentifier: identifier)
        didCallRegisterCell = true
    }

}

class TestTableViewCell: UITableViewCell {

    // MARK: - Properties
    let label = UILabel()
    let button = UIButton()

    // MARK: - Inits
    override init(style: CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        label.numberOfLines = 1
        doLayout()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }

    // MARK: - Private Instance Methods
    private func doLayout() {
        addSubview(label)
        addSubview(button)

        label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16).isActive = true
        label.topAnchor.constraint(equalTo: topAnchor, constant: 8).isActive = true
        label.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8).isActive = true

        button.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16).isActive = true
        button.topAnchor.constraint(equalTo: topAnchor, constant: 8).isActive = true
        button.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8).isActive = true

        label.translatesAutoresizingMaskIntoConstraints = false
        button.translatesAutoresizingMaskIntoConstraints = false
    }

}
