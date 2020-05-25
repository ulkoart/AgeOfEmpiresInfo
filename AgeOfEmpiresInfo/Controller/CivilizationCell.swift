//
//  CivilizationCell.swift
//  AgeOfEmpiresInfo
//
//  Created by user on 25/05/2020.
//  Copyright © 2020 Artem Ulko. All rights reserved.
//

import UIKit

class CivilizationCell: UITableViewCell {
    @IBOutlet weak var civilizationNamelabel: UILabel!
    @IBOutlet weak var civilizationExpansionLabel: UILabel!
    
    func setup(with civilization: Civilization) {
        civilizationNamelabel.text = civilization.name
        civilizationExpansionLabel.text = civilization.expansion.rawValue
    }
    
}
