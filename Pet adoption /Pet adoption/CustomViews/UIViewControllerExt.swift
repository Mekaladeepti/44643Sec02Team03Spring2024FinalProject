import UIKit

 

extension UIView {
    
    func dropShadow(scale: Bool = true , height:Int = 3 , shadowRadius:CGFloat = 3,radius:CGFloat = 0) {
        layer.masksToBounds = false
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.2
        layer.shadowOffset = CGSize(width: -1, height: height)
        layer.shadowRadius = shadowRadius
        layer.shouldRasterize = true
        layer.rasterizationScale = scale ? UIScreen.main.scale : 1
        layer.cornerRadius = radius
    }
    
    func roundCorners(corners: UIRectCorner, radius: CGFloat) {
         let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
         let mask = CAShapeLayer()
         mask.path = path.cgPath
         layer.mask = mask
     }
    
    static var nib: UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
    
    static var identifier: String {
        return String(describing: self)
    }
    
    
}


func showAlertView(message:String){
   DispatchQueue.main.async {
   let alert = UIAlertController(title: "Message", message: message, preferredStyle: .alert)
   let action = UIAlertAction(title: "Ok", style: .default) { (alert) in
      // completion?(true)
   }
   alert.addAction(action)
   UIApplication.topViewController()!.present(alert, animated: true, completion: nil)
   }
}

func showGlobalOkeyAlert(message:String,completion:@escaping () -> Void){
   DispatchQueue.main.async {
   let alert = UIAlertController(title: "Message", message: message, preferredStyle: .alert)
   let action = UIAlertAction(title: "Ok", style: .default) { (alert) in
       completion()
   }
   alert.addAction(action)
   UIApplication.topViewController()!.present(alert, animated: true, completion: nil)
   }
  
}

func showConfirmationAlert(message: String, yesHandler: ((UIAlertAction) -> Void)?) {
        let alertController = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
        let yesAction = UIAlertAction(title: "Yes", style: .default, handler: yesHandler)
        let noAction = UIAlertAction(title: "No", style: .cancel, handler: nil)
        alertController.addAction(yesAction)
        alertController.addAction(noAction)
        UIApplication.topViewController()!.present(alertController, animated: true, completion: nil)
}

extension UIApplication {
    class func topViewController(controller: UIViewController? = UIApplication.shared.windows.first?.rootViewController) -> UIViewController? {
        if let navigationController = controller as? UINavigationController {
            return topViewController(controller: navigationController.visibleViewController)
        }
        if let tabController = controller as? UITabBarController {
            if let selected = tabController.selectedViewController {
                return topViewController(controller: selected)
            }
        }
        if let presented = controller?.presentedViewController {
            return topViewController(controller: presented)
        }
        return controller
    }
}


extension String {
    
    func emailIsCorrect() -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: self)
    }
    
    func isValidPhoneNumber(_ phoneNumber: String) -> Bool {
        let phoneRegex = #"^\d{10}$"#
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", phoneRegex)
        return phoneTest.evaluate(with: phoneNumber)
    }
}



extension UITableView {
    
    func registerCells(_ cells : [UITableViewCell.Type]) {
        for cell in cells {
            self.register(UINib(nibName: String(describing: cell), bundle: Bundle.main), forCellReuseIdentifier: String(describing: cell))
        }
    }
}

 
extension UICollectionView {
    
    func registerCells(_ cells : [UICollectionViewCell.Type]) {
        for cell in cells {
            self.register(UINib(nibName: String(describing: cell), bundle: Bundle.main), forCellWithReuseIdentifier: String(describing: cell))
        }
    }
}

 

 


extension String {
    func encodedURL() -> String {
        
        return self.replacingOccurrences(of: " ", with: "%20")
        //return self.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
    }
}

extension String {
    func toURL() -> URL? {
        return URL(string: self)
    }
    func toDouble() -> Double? {
        return NumberFormatter().number(from: self)?.doubleValue
    }
}

 
extension UIButton {
    private struct AssociatedKeys {
        static var tapClosure = "tapClosure"
    }

    typealias ButtonTapClosure = () -> Void

    private var tapClosure: ButtonTapClosure? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.tapClosure) as? ButtonTapClosure
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.tapClosure, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }

    func onTap(_ closure: @escaping ButtonTapClosure) {
        self.tapClosure = closure
        addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
    }

    @objc private func buttonTapped() {
        tapClosure?()
    }
}
 
