//
//  SnapsViewController.swift
//  Snap
//
//  Created by Kanix Lau on 12/1/2017.
//  Copyright © 2017年 KanixLau. All rights reserved.
//

import UIKit

class SnapsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func logoutBtn(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

}
