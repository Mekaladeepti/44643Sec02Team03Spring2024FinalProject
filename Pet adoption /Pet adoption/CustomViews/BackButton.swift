//
//  BackButton.swift
//  Pet adoption
//
//  Created by Srilakshmi on 3/8/24.
//

import UIKit

class BackButton: UIButton {
    
    override func awakeFromNib() {
        self.addTarget(self, action: #selector(goBack), for: .touchUpInside)
    }
    
    @objc func goBack(sender: UIButton) {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let delegate = windowScene.delegate as? SceneDelegate,
              var topController = delegate.window?.rootViewController
        else { return }
        
        while let presentedViewController = topController.presentedViewController {
            topController = presentedViewController
        }
        
        if let navigationController = topController as? UINavigationController, navigationController.viewControllers.count > 1 {
            navigationController.popViewController(animated: true)
        } else {
            // If not, dismiss this view controller
            topController.dismiss(animated: true, completion: nil)
        }
    }
}
