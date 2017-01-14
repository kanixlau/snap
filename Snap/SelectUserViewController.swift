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
import FirebaseAuth

class SelectUserViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    var users : [User] = []
    
    var imageURL = ""
    var descrip = ""
    var uuid = ""
    
    var ref : FIRDatabaseReference = FIRDatabase.database().reference()
    
    let currentUserEmail = FIRAuth.auth()?.currentUser?.email

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        //Pull user data from Firebase
        
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let user = users[indexPath.row]
        
        let snap = ["from":currentUserEmail, "description": descrip, "imageURL":imageURL, "uuid": uuid]
        
        ref.child("users").child(user.uid).child("snaps").childByAutoId().setValue(snap)
        
        navigationController!.popToRootViewController(animated: true)
    }

}
