//
//  SignInViewController.swift
//  Snap
//
//  Created by Kanix Lau on 8/1/2017.
//  Copyright © 2017年 KanixLau. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

class SignInViewController: UIViewController {
    
    @IBOutlet weak var emailText: UITextField!
    
    @IBOutlet weak var passwordText: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
    }
    
    @IBAction func goButton(_ sender: Any) {
        
        FIRAuth.auth()?.signIn(withEmail: emailText.text!, password: passwordText.text!, completion: { (user, error) in
            print("We are trying to sign in with the entered user details")
            if error != nil {
                print("There is an error: \(error)")
                
                FIRAuth.auth()?.createUser(withEmail: self.emailText.text!, password: self.passwordText.text!, completion: { (user, error) in
                    print("We are trying to create the user")
                    
                    if error != nil {
                        print("There is an error: \(error)")
                    } else {
                        print("User created successfully")
                        
                        //Create user on Firebase by using the user uid and the email
                        FIRDatabase.database().reference().child("users").child(user!.uid).child("email").setValue(user!.email)
                        
                        self.performSegue(withIdentifier: "signinsegue", sender: nil)
                    }
                })
            } else {
                print("Signed in successfully")
                self.performSegue(withIdentifier: "signinsegue", sender: nil)
            }
        })
    }
    
}

