 
import UIKit

class AnimationScreen: UIViewController {

 
    override func viewWillAppear(_ animated: Bool) {
       
        playSound(name: "dogSound")
        // Add a delay of 3 seconds before navigating to the home screen
         DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                    SceneDelegate.shared?.setHomeScreen()
         }
    }

}
