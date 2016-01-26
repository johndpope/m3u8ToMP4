//
//  PlayerView.swift
//  m3u8ToMp4
//
//  Created by Jay on 16/1/22.
//  Copyright © 2016年 imooc. All rights reserved.
//

import UIKit
import AVFoundation
class PlayerView: UIView {
    private var player : AVPlayer?{
        didSet{
            let selfLayer = layer as! AVPlayerLayer
            selfLayer.player = player
        }
    }
    
   override class func layerClass() -> AnyClass {
        return AVPlayerLayer.self
    }
    
    func playVideoWithURL(url:NSURL){
        let playerItem = AVPlayerItem.init(URL: url)
        
        player = AVPlayer.init(playerItem: playerItem)
        player?.rate = 1.0
        
    }
    
}

extension PlayerView{
    
}