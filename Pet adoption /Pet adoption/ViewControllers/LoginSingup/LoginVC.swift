
import UIKit

class LoginViewController: UIViewController {
   
   @IBOutlet weak var email: UITextField!
   @IBOutlet weak var password: UITextField!
   

    @IBAction func onLoginButtonClick(_ sender: Any) {
    
            if(email.text!.isEmpty) {
                showAlertView(message: "Please enter your email.")
                return
            }else  if(self.password.text!.isEmpty) {
                showAlertView(message: "Please enter your password.")
                return
            }else {
          
                FireDbHelper.shared.loginUser(email: email.text!.lowercased(), password: password.text!) { success in
                    if success{
                        SceneDelegate.shared?.setHomeScreen()
                    }
                    
                }
            }
    }
    
    
    @IBAction func onLockButtonPressed(_ sender: UIButton) {
        
        self.password.isSecureTextEntry.toggle()
    
        let buttonImageName = password.isSecureTextEntry ? "lock" : "lock.open"
            if let buttonImage = UIImage(systemName: buttonImageName) {
                sender.setImage(buttonImage, for: .normal)
        }
    }
    
}





