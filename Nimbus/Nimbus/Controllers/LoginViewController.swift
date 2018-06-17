//
//  ViewController.swift
//  Nimbus
//
//  Created by Pirush Prechathavanich on 6/14/18.
//  Copyright © 2018 Nimbl3. All rights reserved.
//

import Cocoa

typealias CompletionHandler = () -> Void

class LoginViewController: NSViewController {
    
    @IBOutlet weak var emailTextField: NSTextField!
    @IBOutlet weak var passwordTextField: NSSecureTextField!
    
    @IBOutlet weak var loginButton: NSButton!
    
    var onSignInWithCredentials: ((_ email: String, _ password: String) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        emailTextField.layer?.cornerRadius = 8.0
        passwordTextField.layer?.cornerRadius = 8.0
        // Do any additional setup after loading the view.
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    
    @IBAction func didSelectSignIn(_ sender: Any) {
        onSignInWithCredentials?(
            emailTextField.stringValue,
            passwordTextField.stringValue
        )
    }
    
}
