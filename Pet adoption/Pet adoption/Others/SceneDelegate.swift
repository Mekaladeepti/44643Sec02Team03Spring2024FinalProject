//
//  SceneDelegate.swift
//  Petadoption
//
//  Created by Durga Sambhavi Mamillapalli on 3/4/24.
//
import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
   
   static var shared: SceneDelegate?
   
   var tempScene : UIScene!
   
   var window: UIWindow?
   

   func setHomeScreen() {
      
       guard let windowScene = (tempScene as? UIWindowScene) else { return }
       
       SceneDelegate.shared = self
       
       window = UIWindow(frame: windowScene.coordinateSpace.bounds)
       window?.windowScene = windowScene
       var navigationController: UINavigationController!
   
       if (UserDefaultsDb.shared.isLoggedIn()) {
           
               let initialViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "HomeNavigationController")
               navigationController = UINavigationController(rootViewController: initialViewController)
               navigationController.navigationBar.isHidden = false
               
         
           
       }else {
           let initialViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
           navigationController = UINavigationController(rootViewController: initialViewController)
           navigationController.navigationBar.isHidden = false
       }
       
       self.window?.rootViewController = navigationController
       window?.makeKeyAndVisible()
   }
   
   func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
       SceneDelegate.shared = self
      
       self.tempScene = scene
      
   }
   
   func sceneDidBecomeActive(_ scene: UIScene) {
       // Called when the scene has moved from an inactive state to an active state.
       // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
   }
   
   func sceneWillResignActive(_ scene: UIScene) {
       // Called when the scene will move from an active state to an inactive state.
       // This may occur due to temporary interruptions (ex. an incoming phone call).
   }
   
   func sceneWillEnterForeground(_ scene: UIScene) {
       // Called as the scene transitions from the background to the foreground.
       // Use this method to undo the changes made on entering the background.
   }
   
   func sceneDidEnterBackground(_ scene: UIScene) {
       // Called as the scene transitions from the foreground to the background.
       // Use this method to save data, release shared resources, and store enough scene-specific state information
       // to restore the scene back to its current state.
   }
   
   
}


