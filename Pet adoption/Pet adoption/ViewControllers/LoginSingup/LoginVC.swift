//
//  LoginViewController.swift
//  Petadoption
//
//  Created by MekalaDeepthi on 3/4/24.
//
import UIKit

class LoginViewController: UIViewController {
   
   @IBOutlet weak var email: UITextField!
   @IBOutlet weak var password: UITextField!
   
 
    
    
    @IBAction func onLockButtonPressed(_ sender: UIButton) {
        
        self.password.isSecureTextEntry.toggle()
    
        let buttonImageName = password.isSecureTextEntry ? "lock" : "lock.open"
            if let buttonImage = UIImage(systemName: buttonImageName) {
                sender.setImage(buttonImage, for: .normal)
        }
    
    }
    
    @IBAction func onLoginButtonClick(_ sender: Any) {
        if(email.text!.isEmpty) {
            showAlertView(message: "Please enter your email.")
            return
        }else if  (self.password.text!.isEmpty) {
            showAlertView(message: "Please enter your password.")
            return
        
                
            }
        func showAlertView(message: String) {
                let alert = UIAlertController(title: "Warning", message: message, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                present(alert, animated: true, completion: nil)
            }
        
    }
    
}





