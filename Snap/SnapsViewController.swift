//
//  SnapsViewController.swift
//  Snap
//
//  Created by Kanix Lau on 12/1/2017.
//  Copyright © 2017年 KanixLau. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

class SnapsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    var snaps: [Snap] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        let ref : FIRDatabaseReference = FIRDatabase.database().reference()
        
        //Below will be executed if any Child is added
        ref.child("users").child((FIRAuth.auth()?.currentUser?.uid)!).child("snaps").observe(.childAdded, with: { (snapshot) in
            let value = snapshot.value as? [String:Any]
            
            print(snapshot)
            
            
            let snap = Snap()
            
            snap.imageURL = value?["imageURL"] as! String
            snap.descrip = value?["description"] as! String
            snap.from = value?["from"] as! String
            snap.key = snapshot.key
            snap.uuid = value?["uuid"] as! String
            
            self.snaps.append(snap)
            self.tableView.reloadData()
            
        })
        
        //Below will be executed if any Child is removed
        ref.child("users").child((FIRAuth.auth()?.currentUser?.uid)!).child("snaps").observe(.childRemoved, with: { (snapshot) in
            
            var index = 0
            for snap in self.snaps {
                if snap.key == snapshot.key {
                    self.snaps.remove(at: index)
                }
                index += 1
            }
            
            self.tableView.reloadData()
        })
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if snaps.count == 0 {
            return 1
        } else {
            return snaps.count
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        
        if snaps.count == 0 {
            cell.textLabel?.text = "There is no snaps"
            return cell
        } else {
        
        let snap = snaps[indexPath.row]
        
        cell.textLabel?.text = snap.from
        
        return cell
            
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let snap = snaps[indexPath.row]
        
        performSegue(withIdentifier: "viewsnapsegue", sender: snap)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "viewsnapsegue" {
            
            let nextVC = segue.destination as! ViewSnapViewController
            nextVC.snap = sender as! Snap
            
        }
    }
    
    @IBAction func logoutBtn(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
}
