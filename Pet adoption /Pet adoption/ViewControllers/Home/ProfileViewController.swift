
import UIKit


class ProfileViewController: UIViewController,UITextFieldDelegate {
    
    @IBOutlet weak var fullName: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var mobile: UITextField!
    @IBOutlet weak var userType: UILabel!
    let userDefaults = UserDefaultsDb.shared
    var documentId = ""
    
    override func viewDidLoad() {
        fullName.delegate = self
        mobile.delegate = self
        self.userType.text = "Welcome"
    }
  
    override func viewWillAppear(_ animated: Bool) {
        
        self.email.text = userDefaults.getEmail()
        
        FireDbHelper.shared.dbRef.document(userDefaults.getDocumentId()).getDocument { (document, error) in
            if error != nil {
                
            } else {
                if let document = document, document.exists {
                    if let data = document.data() {
                        self.fullName.text = data["name"] as? String ?? ""
                        self.mobile.text = data["mobile"] as? String ?? ""
                        // self.address.text = data["address"] as? String ?? ""
                        self.documentId = document.documentID
                    }
                } else {
                    print("Document does not exist")
                }
            }
        }
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        view.endEditing(true)
        
        
        //            let commonVC = storyboard?.instantiateViewController(withIdentifier: "CommonUpdateVC") as! CommonUpdateVC
        //            commonVC.oldValue = textField.text!
        //            commonVC.changeFor = textField.placeholder!
        //            navigationController?.pushViewController(commonVC, animated: true)
        
        
        return false
    }
    
    
    
    @IBAction func logOutAction(_ sender: Any) {
        
        showConfirmationAlert(message: "Are you sure you want to logout?") { _ in
            self.userDefaults.resetData()
            SceneDelegate.shared?.setHomeScreen()
            
        }
        
    }
    
    @IBAction func onMyMeeting(_ sender: Any) {
        
        let commonVC = storyboard?.instantiateViewController(withIdentifier: "MeetingHistoryVC") as! MeetingHistoryVC
        commonVC.myMeeting = true
        navigationController?.pushViewController(commonVC, animated: true)
        
    }
    
    @IBAction func onReceived(_ sender: Any) {
        
        let commonVC = storyboard?.instantiateViewController(withIdentifier: "MeetingHistoryVC") as! MeetingHistoryVC
        commonVC.myMeeting = false
        navigationController?.pushViewController(commonVC, animated: true)
        
    }
    
    
}


extension ProfileViewController {
    

    @IBAction func onAbout(_ sender: Any) {
        
        
    }
    
}
