//
//  AddingViewController.swift
//  Snap
//
//  Created by Kanix Lau on 12/1/2017.
//  Copyright © 2017年 KanixLau. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage

class AddingViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var nextBtnOutlet: UIButton!
    
    var imagePicker = UIImagePickerController()
    var uuid = NSUUID().uuidString
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePicker.delegate = self
        nextBtnOutlet.isEnabled = false

        // Do any additional setup after loading the view.
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        
        imageView.image = image
        imageView.backgroundColor = UIColor.clear
        nextBtnOutlet.isEnabled = true
        
        imagePicker.dismiss(animated: true, completion: nil)

    }
    
    @IBAction func searchBtn(_ sender: Any) {
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }
    

    @IBAction func cameraBtn(_ sender: Any) {
        
        imagePicker.sourceType = .camera
        present(imagePicker, animated: true, completion: nil)
        
    }
    
    @IBAction func nextBtn(_ sender: Any) {
        
        nextBtnOutlet.isEnabled = false
        
        let imagesFolder = FIRStorage.storage().reference().child("images")
        
        let imageData = UIImageJPEGRepresentation(imageView.image!, 0.1)!
        
        imagesFolder.child("\(uuid).jpg").put(imageData, metadata: nil) { (metadata, error) in
            print("We tried to update!")
            
            if error != nil {
                print("We had an error:\(error)")
            } else {
                
                self.performSegue(withIdentifier: "selectUsersegue", sender: metadata?.downloadURL()!.absoluteString)
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let nextVC = segue.destination as! SelectUserViewController
        nextVC.imageURL = sender as! String
        nextVC.descrip = textField.text!
        nextVC.uuid = uuid
    }
    
}
