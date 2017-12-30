//
//  ActivityViewController.swift
//  MemeMeDraft3
//
//  Created by ALCALY LO on 12/29/17.
//  Copyright © 2017 ALCALY LO. All rights reserved.
//

import UIKit

class ActivityViewController: UIViewController {

    
    @IBOutlet weak var Cancel: UIBarButtonItem!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    @IBAction func dismiss () {
        self.dismiss( animated: true, completion: nil)
    }

}
