//
//  PlayerViewToolBar.swift
//  m3u8ToMp4
//
//  Created by Jay on 16/1/27.
//  Copyright © 2016年 imooc. All rights reserved.
//

import UIKit

class PlayerViewToolBar: UIView {
    @IBOutlet weak var bottomBar: UIView!
    
    @IBOutlet weak var playPauseButton: UIButton!
    @IBOutlet weak var fullSmallButton: UIButton!
    @IBOutlet weak var timeTabel: UILabel!
    @IBOutlet weak var slider: UISlider!
    
    weak var delegate: PlayerViewToolBarDelegate?
    
    required init?(coder aDecoder: NSCoder){
        super.init(coder: aDecoder)
        self.backgroundColor = UIColor.clearColor()
        
        
    }
    
    override func awakeFromNib() {
        slider.setThumbImage(UIImage(named: "thumbImage"), forState: UIControlState.Normal)
    }
    override func didMoveToSuperview() {
        //        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(1 * Double(NSEC_PER_SEC))), dispatch_get_main_queue()) { () -> Void in
        //            self.hideBar()
        //        }
    }
}
extension PlayerViewToolBar{
    func isPlaying(value:Bool){
        if value {
            playPauseButton.setTitle("暂停", forState: UIControlState.Normal)
        }else{
            playPauseButton.setTitle("播放", forState: UIControlState.Normal)
        }
    }
    func currentValue(value: Float){
        slider.value = value
    }
    func updateTimelabel(currentTime:Double,totalTime:Double){
        print("\(currentTime)    \(totalTime)")
        let currentTimeString = currentTime.secondsDescription()
        let totalTimeString = totalTime.secondsDescription()
        let string = currentTimeString+"/"+totalTimeString
        
        let attribute = NSMutableAttributedString.init(string: string);
        
        let dictionary1:[String:AnyObject] = [NSFontAttributeName:UIFont.systemFontOfSize(11),
            NSForegroundColorAttributeName:UIColor(red: 153, green: 153, blue: 153, alpha: 1)]
        let range1 = (string as NSString).rangeOfString(currentTimeString)
        attribute.addAttributes(dictionary1, range: range1)
        
        let dictionary2:[String:AnyObject] = [NSFontAttributeName:UIFont.systemFontOfSize(11),
            NSForegroundColorAttributeName:UIColor.blackColor()]
        let range2 = (string as NSString).rangeOfString("/"+totalTimeString)
        attribute.addAttributes(dictionary2, range: range2)
        attribute.endEditing()
        timeTabel.attributedText = attribute
    }
    func loadedProgress(value: Float){
        
    }
    
}
extension Double{
    func secondsDescription()->String{
        // MARK 这里精度的问题可能会跳来跳去。后期再处理
        if self.isNaN {
            return ""
        }
        let minute = Int(self/60)
        let second = Int(self%60)
        var string1 = ""
        var string2 = ""
        if minute < 10 {
            string1 = "0" + "\(minute)"
        }else{
            string1 = "\(minute)"
        }
        if second < 10 {
            string2 = "0" + "\(second)"
        }else{
            string2 = "\(second)"
        }
        let string =  string1 + ":" + string2
        return string
    }
}
extension PlayerViewToolBar{
//    func
}
extension PlayerViewToolBar{
    func hideBar(){
        UIView.animateWithDuration(0.35, animations: { () -> Void in
            self.bottomBar.alpha = 0.0
            }) { (result) -> Void in
                //
        }
    }
    func showBar(){
        UIView.animateWithDuration(0.35) { () -> Void in
            self.bottomBar.alpha = 1.0
            
        }
    }
}
extension PlayerViewToolBar{
    @IBAction func onClickPlayPauseButton(){
        delegate?.playPauseAction()
    }
    
    @IBAction func onClickFullSmallButton(){
        print("暂不支持全屏切换")
    }
    
    @IBAction func taped(){
        if bottomBar.alpha == 1.0 {
            hideBar()
        }else{
            showBar()
        }
    }
}

protocol PlayerViewToolBarDelegate: class {
    // Action
    func playPauseAction()
    func fullSmallAction()
    
}