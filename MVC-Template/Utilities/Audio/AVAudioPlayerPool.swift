import UIKit
import AVFoundation

private var players:[AVAudioPlayer] = []

class AVAudioPlayerPool: NSObject {
    
    func playerWithURL(url:URL) -> AVAudioPlayer? {
            
            //Find an idle AVAudioPlayer
            let availablePlayers = players.filter { (player) -> Bool in
                return player.isPlaying == false && player.url == url
            }
            
            //If found, return AVAudioPlayer object
            if let playerToUse = availablePlayers.first{
                return playerToUse
            }
            
            //Not found, create a new AVAudioPlayer object
            do {
                let newPlayer = try AVAudioPlayer(contentsOf: url)
                players.append(newPlayer)
                return newPlayer
            } catch {
                print(error)
            }
            return nil
        }

}
