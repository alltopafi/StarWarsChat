//
//  loginViewController+handlers.swift
//  starwarschat
//
//  Created by Jesse Alltop on 12/30/16.
//  Copyright © 2016 Jesse Alltop. All rights reserved.
//

import UIKit
import Firebase

extension loginViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func handleSelectImageView() {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        present(picker, animated: true, completion: nil)
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        var selectedImage: UIImage?
        
        if let editedImage = info["UIImagePickerControllerEditedImage"] as? UIImage {
            selectedImage = editedImage
        }else if let originalImage = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            selectedImage = originalImage
        }
        
        if let pickedImage = selectedImage {
            profileImageView.image = pickedImage
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func handleLoginRegisterChange(){
        let title = loginRegisterSegmentedControl.titleForSegment(at: loginRegisterSegmentedControl.selectedSegmentIndex)
        loginRegisterButton.setTitle(title, for: .normal)
        
        inputContainerViewHeightAnchor?.constant =
            loginRegisterSegmentedControl.selectedSegmentIndex == 0 ? 100 : 150
        
        nameFieldHeightAnchor?.isActive = false
        nameFieldHeightAnchor = nameField.heightAnchor.constraint(equalTo: inputContainerView.heightAnchor, multiplier:  loginRegisterSegmentedControl.selectedSegmentIndex == 0 ? 0 : 1/3)
        nameField.placeholder = loginRegisterSegmentedControl.selectedSegmentIndex == 0 ? "" : "Name"
        nameFieldHeightAnchor?.isActive = true
        
        emailFieldHeightAnchor?.isActive = false
        emailFieldHeightAnchor = emailField.heightAnchor.constraint(equalTo: inputContainerView.heightAnchor, multiplier: loginRegisterSegmentedControl.selectedSegmentIndex == 0 ? 1/2 : 1/3)
        emailFieldHeightAnchor?.isActive = true
        
        passwordFieldHeightAnchor?.isActive = false
        passwordFieldHeightAnchor = passwordField.heightAnchor.constraint(equalTo: inputContainerView.heightAnchor, multiplier: loginRegisterSegmentedControl.selectedSegmentIndex == 0 ? 1/2 : 1/3)
        passwordFieldHeightAnchor?.isActive = true
        
    }
    
    func handleLoginRegister() {
        if loginRegisterSegmentedControl.selectedSegmentIndex == 0 {
            handleLogin()
        }else{
            handleRegister()
        }
    }
    
    func handleLogin() {
        guard let email = emailField.text, let password = passwordField.text else {
            print("not a valid form")
            return
        }
        
        FIRAuth.auth()?.signIn(withEmail: email, password: password, completion: { (user, error) in
            if error != nil {
                print(error!)
                return
            }
            
            self.dismiss(animated: true, completion: nil)
            
        })
    }
    
    
    func handleRegister(){
        guard let email = emailField.text, let password = passwordField.text, let name = nameField.text else {
            print("not a valid form")
            return
        }
        
        FIRAuth.auth()?.createUser(withEmail: email, password: password, completion: { (user: FIRUser?, error) in
            
            if error != nil {
                print(error!)
                return
            }
            
            guard let uid = user?.uid else {
                return
            }
            
            let imageName = NSUUID().uuidString
            
            let storageRef = FIRStorage.storage().reference().child("profile_images").child("\(imageName).png")
            
            if let uploadData = UIImagePNGRepresentation(self.profileImageView.image!) {
                
                storageRef.put(uploadData, metadata: nil, completion: { (metaData, error) in
                    
                    if error != nil {
                        print(error!)
                        return
                    }

                    if let profileImageUrl = metaData?.downloadURL()?.absoluteString {
                        
                        let values = ["name": name, "email": email, "profileImageUrl": profileImageUrl]
                        
                        self.registerUserToDatabaseWithUid(uid: uid, values: values as [String : AnyObject])
                    }
                    
                   
                    
                    
                })
                
            }
            
        })
    }
    
    private func registerUserToDatabaseWithUid(uid: String, values: [String: AnyObject]) {
    
        //created a new user
        let ref = FIRDatabase.database().reference()
        let userRef = ref.child("users").child(uid)
        userRef.updateChildValues(values, withCompletionBlock: { (err, ref) in
            
            if err != nil {
                print(err!)
                return
            }
            
            print("saved user to db")
            self.dismiss(animated: true, completion: nil)
        })
   
    }
    
}
