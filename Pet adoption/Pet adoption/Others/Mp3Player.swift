
import Foundation
import AVFoundation


var localSoundPlayer: AVAudioPlayer?

func playLocalSound(soundName:String) {

   guard let url = Bundle.main.url(forResource: soundName, withExtension: "mp3") else { return }

   do {
       try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback)
       try AVAudioSession.sharedInstance().setActive(true)

       localSoundPlayer = try AVAudioPlayer(contentsOf: url)
       guard let player = localSoundPlayer else { return }

       player.play()
   } catch let error {
       print(error.localizedDescription)
   }
}





func playSound(name:String) {
   playLocalSound(soundName: name)
}
