//
//  loginViewController.swift
//  starwarschat
//
//  Created by Jesse Alltop on 12/30/16.
//  Copyright © 2016 Jesse Alltop. All rights reserved.
//

import UIKit
import Firebase

class loginViewController: UIViewController {
    
    var ref: FIRDatabaseReference!
    var messagesController: MessagesController?
    
    lazy var profileImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "starwarslogo")
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFill
        
        iv.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleSelectImageView)))
        iv.isUserInteractionEnabled = true
        
        return iv
    }()
    
    
    
    lazy var loginRegisterSegmentedControl: UISegmentedControl = {
       let sc = UISegmentedControl(items: ["Login", "Register"])
       sc.translatesAutoresizingMaskIntoConstraints = false
       sc.tintColor = UIColor.white
       sc.selectedSegmentIndex = 1
       sc.addTarget(self, action: #selector(handleLoginRegisterChange), for: .valueChanged)
       return sc
    }()
    

    
    let inputContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.gray
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 5
        view.layer.masksToBounds = true
        return view
    }()
    
    lazy var loginRegisterButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = UIColor.gray
        button.setTitle("Register", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 5
        button.layer.masksToBounds = true
        button.setTitleColor(UIColor.white, for: .normal)
        button.addTarget(self, action: #selector(handleLoginRegister), for: .touchUpInside)
        return button
    }()
    

    
    let nameField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Name"
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    let emailField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Email address"
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    let passwordField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Password"
        tf.isSecureTextEntry = true
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    let nameSeparatorView: UIView = {
       let view = UIView()
        view.backgroundColor = UIColor.darkGray
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let emailSeparatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.darkGray
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.black
        self.view.addSubview(inputContainerView)
        self.view.addSubview(loginRegisterButton)
        self.view.addSubview(profileImageView)
        self.view.addSubview(loginRegisterSegmentedControl)
        setupInputFields()
        setupLoginRegisterButton()
        setupImageView()
        setupLoginRegisterSegmentedControl()
    }
    
    func setupLoginRegisterSegmentedControl() {
        //need x, y, width, height constraints
        loginRegisterSegmentedControl.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        loginRegisterSegmentedControl.bottomAnchor.constraint(equalTo: inputContainerView.topAnchor, constant: -12).isActive = true
        loginRegisterSegmentedControl.widthAnchor.constraint(equalTo: inputContainerView.widthAnchor).isActive = true
        loginRegisterSegmentedControl.heightAnchor.constraint(equalToConstant: 36).isActive = true
    }
    
    var inputContainerViewHeightAnchor: NSLayoutConstraint?
    var nameFieldHeightAnchor: NSLayoutConstraint?
    var emailFieldHeightAnchor: NSLayoutConstraint?
    var passwordFieldHeightAnchor: NSLayoutConstraint?
    
    func setupInputFields(){
        //need x, y, width, height constraints
        inputContainerView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        inputContainerView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        inputContainerView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -24).isActive = true
        
        inputContainerViewHeightAnchor =
        inputContainerView.heightAnchor.constraint(equalToConstant: 150)
        
        inputContainerViewHeightAnchor?.isActive = true
        
        inputContainerView.addSubview(nameField)
        //need x, y, width, height constraints
        nameField.leftAnchor.constraint(equalTo: inputContainerView.leftAnchor, constant: 12).isActive = true
        nameField.topAnchor.constraint(equalTo: inputContainerView.topAnchor).isActive = true
        nameField.widthAnchor.constraint(equalTo: inputContainerView.widthAnchor).isActive = true
        
        nameFieldHeightAnchor =
        nameField.heightAnchor.constraint(equalTo: inputContainerView.heightAnchor, multiplier: 1/3)
        nameFieldHeightAnchor?.isActive = true
        
        
        inputContainerView.addSubview(nameSeparatorView)
        //need x, y, width, height constraints
        nameSeparatorView.leftAnchor.constraint(equalTo: inputContainerView.leftAnchor).isActive = true
        nameSeparatorView.topAnchor.constraint(equalTo: nameField.bottomAnchor).isActive = true
        nameSeparatorView.widthAnchor.constraint(equalTo: inputContainerView.widthAnchor).isActive = true
        nameSeparatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        inputContainerView.addSubview(emailField)
        //need x, y, width, height constraints
        emailField.leftAnchor.constraint(equalTo: inputContainerView.leftAnchor, constant: 12).isActive = true
        emailField.topAnchor.constraint(equalTo: nameField.bottomAnchor).isActive = true
        emailField.widthAnchor.constraint(equalTo: inputContainerView.widthAnchor).isActive = true
        
        emailFieldHeightAnchor =
            emailField.heightAnchor.constraint(equalTo: inputContainerView.heightAnchor, multiplier: 1/3)
            emailFieldHeightAnchor?.isActive = true

        inputContainerView.addSubview(emailSeparatorView)
        //need x, y, width, height constraints
        emailSeparatorView.leftAnchor.constraint(equalTo: inputContainerView.leftAnchor).isActive = true
        emailSeparatorView.topAnchor.constraint(equalTo: emailField.bottomAnchor).isActive = true
        emailSeparatorView.widthAnchor.constraint(equalTo: inputContainerView.widthAnchor).isActive = true
        emailSeparatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        
        inputContainerView.addSubview(passwordField)
        //need x, y, width, height constraints
        passwordField.leftAnchor.constraint(equalTo: inputContainerView.leftAnchor, constant: 12).isActive = true
        passwordField.topAnchor.constraint(equalTo: emailField.bottomAnchor).isActive = true
        passwordField.widthAnchor.constraint(equalTo: inputContainerView.widthAnchor).isActive = true
        passwordFieldHeightAnchor =
        passwordField.heightAnchor.constraint(equalTo: inputContainerView.heightAnchor, multiplier: 1/3)
        passwordFieldHeightAnchor?.isActive = true
    
        
    }
    
    func setupLoginRegisterButton() {
        //need x, y, width, height constraints
        loginRegisterButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        loginRegisterButton.topAnchor.constraint(equalTo: inputContainerView.bottomAnchor, constant: 12).isActive = true
        loginRegisterButton.widthAnchor.constraint(equalTo: inputContainerView.widthAnchor).isActive = true
        loginRegisterButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    func setupImageView() {
        //need x, y, width, height constraints
        profileImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        profileImageView.bottomAnchor.constraint(equalTo: loginRegisterSegmentedControl.topAnchor, constant: -12).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 150).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 150).isActive = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}

