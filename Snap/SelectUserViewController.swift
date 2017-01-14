//
//  SelectUserViewController.swift
//  Snap
//
//  Created by Kanix Lau on 14/1/2017.
//  Copyright © 2017年 KanixLau. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class SelectUserViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    var users : [User] = []
    
    var ref : FIRDatabaseReference!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        //Pull user data from Firebase
        ref = FIRDatabase.database().reference()
        
        ref.child("users").observe(.childAdded, with: { (snapshot) in
            let value = snapshot.value as? [String:Any]
            
            let user = User()
            user.uid = snapshot.key
            user.email = value?["email"] as! String
            
            self.users.append(user)
            self.tableView.reloadData()
            
            print(snapshot)
            
        })

    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        
        let user = users[indexPath.row]
        
        cell.textLabel?.text = user.email
        
        return cell
    }

}
