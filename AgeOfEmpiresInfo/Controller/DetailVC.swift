//
//  DetailVC.swift
//  AgeOfEmpiresInfo
//
//  Created by user on 25/05/2020.
//  Copyright © 2020 Artem Ulko. All rights reserved.
//

import UIKit

class DetailVC: UIViewController {
    
    var civilization: Civilization!
    
    @IBOutlet weak var civilizationNameLabel: UILabel!
    @IBOutlet weak var civilizationExpansionLabel: UILabel!
    @IBOutlet weak var civilizationBonusTextView: UITextView!
    @IBOutlet weak var civilizationArmyTypeLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setUpCivilization()

    }
    
    private func setUpCivilization(){
        civilizationBonusTextView.text = ""
        civilizationBonusTextView.isScrollEnabled = false
        civilizationBonusTextView.sizeToFit()
        civilizationNameLabel.text = civilization.name
        civilizationExpansionLabel.text = "(\(civilization.expansion.rawValue))"
        civilization.civilizationBonus.forEach { (bonus) in
            civilizationBonusTextView.text += "* \(bonus)\n"
        }
        civilizationArmyTypeLabel.text = civilization.armyType
    }
    
    private func setupNavigationBar() {
        if let topItem = navigationController?.navigationBar.topItem {
            topItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        }
        navigationItem.leftBarButtonItem = nil
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
