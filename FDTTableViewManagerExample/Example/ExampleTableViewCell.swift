//
//  ExampleTableViewCell.swift
//  FDTTableViewManagerExample
//
//  Created by Tomasz Korab on 31/03/2019.
//  Copyright © 2019 Tomasz Korab. All rights reserved.
//

import UIKit

class ExampleTableViewCell: UITableViewCell {

    // MARK: - Properties
    let label = UILabel()
    
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
        
        label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16).isActive = true
        label.topAnchor.constraint(equalTo: topAnchor, constant: 8).isActive = true
        label.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16).isActive = true
        label.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8).isActive = true
        
        label.translatesAutoresizingMaskIntoConstraints = false
    }

}
