import UIKit


class CreateAccountVC: UIViewController ,UITextFieldDelegate {
    
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var mobile: UITextField!
   
    override func viewDidLoad() {
        self.title = "Register"
    }
    
    @IBAction func onCreateAccountButtonClick(_ sender: Any) {
        
        if validate(){
            
            FireDbHelper.shared.registerUser(name: self.name.text ?? "", email: self.email.text ?? "", password: self.password.text ?? "", mobile: self.mobile.text!)
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
    
 
extension CreateAccountVC {
 
   
   func validate() ->Bool {
       
       if(self.name.text!.isEmpty) {
           showAlertView(message: "Please enter full name.")
           return false
       }
       
       if(self.email.text!.isEmpty) {
           showAlertView(message: "Please enter email.")
           return false
       }
       
       if !email.text!.emailIsCorrect() {
           showAlertView(message: "Please enter valid email id")
           return false
       }
       
       if(self.mobile.text!.isEmpty) {
           showAlertView(message: "Please enter mobile number.")
           return false
       }
       
       if self.mobile.text!.count != 10 {
           showAlertView(message: "Please enter a valid mobile number with exactly 10 digits")
           return false
       }
       
       if !self.mobile.text!.allSatisfy({ $0.isNumber }) {
           showAlertView(message: "Please enter a valid mobile number with exactly 10 digits")
           return false
       }
       
       if(self.password.text!.isEmpty) {
           showAlertView(message: "Please enter password.")
           return false
       }
       
       if self.password.text!.count < 5 {
               showAlertView(message: "Password must be at least 5 characters long.")
               return false
      }
       
       return true
   }
}



