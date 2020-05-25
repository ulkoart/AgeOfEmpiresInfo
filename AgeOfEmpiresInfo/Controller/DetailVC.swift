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
    
    @IBOutlet weak var civilizationNamelabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        civilizationNamelabel.text = civilization.name
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
