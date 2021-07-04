//
//  AudioCC.swift
//  Cart & Cook
//
//  Created by Development  on 10/06/2021.
//

import UIKit
import AVKit
import Kingfisher
import MediaPlayer

class audioCC: UICollectionViewCell {
    @IBOutlet weak var playbutton: UIButton!
    var timer = Timer()
    var player:AVAudioPlayer!
    @IBOutlet weak var slider: UISlider!
}
