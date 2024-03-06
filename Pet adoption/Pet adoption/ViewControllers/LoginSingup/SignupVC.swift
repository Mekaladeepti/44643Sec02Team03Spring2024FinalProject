//
//  CreateAccountVC.swift
//  Petadoption
//
//  Created by MekalaDeepthi on 3/4/24.
//


import UIKit


class CreateAccountVC: UIViewController ,UITextFieldDelegate {
    
    @IBOutlet weak var firstName: UITextField!
    @IBOutlet weak var lastName: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var userType: UITextField!
    
    
    @IBAction func onLockButtonPressed(_ sender: UIButton) {
        
        self.password.isSecureTextEntry.toggle()
       
        let buttonImageName = password.isSecureTextEntry ? "lock" : "lock.open"
            if let buttonImage = UIImage(systemName: buttonImageName) {
                sender.setImage(buttonImage, for: .normal)
        }
    }
    
    
 
}
    


