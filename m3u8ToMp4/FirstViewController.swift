//
//  FirstViewController.swift
//  m3u8ToMp4
//
//  Created by Jay on 16/1/22.
//  Copyright © 2016年 imooc. All rights reserved.
//

import UIKit
import AVFoundation
class FirstViewController: UIViewController {
    @IBOutlet weak var playerView: PlayerView!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var playVideoButton: UIButton!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    
    var covertVideoFilePath : String?
}

extension FirstViewController{
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        playVideoButton.userInteractionEnabled = false
        label.text = ""
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onClickCovertTS(){
        print("onClickCovertTS()")
        indicator.startAnimating()
        view.userInteractionEnabled = false
        label.text = "开始转换"
        var success = true
        //这里测试DEMO  把资源写死了 其实是 ts在iOS上是不被支持的
//        let string1 = Resource.document() + "/1.mp4"
//        let string2 = Resource.document() + "/2.mp4"
        let string1 = NSBundle.mainBundle().pathForResource("1", ofType: "mp4")
        let string2 = NSBundle.mainBundle().pathForResource("2", ofType: "mp4")
        //ts文件可以在mac下用QuickTime打开，但在iOS平台下却不行，可以学学Mac开发 在OSX平台上试试。
//        let string1 = NSBundle.mainBundle().pathForResource("112", ofType: "ts")
//        let string2 = NSBundle.mainBundle().pathForResource("113", ofType: "ts")
        print(string1!+"\n"+string2!)
        
        let url1 = NSURL.fileURLWithPath(string1!)
        let url2 = NSURL.fileURLWithPath(string2!)
        print(url1.absoluteString!+"\n"+url2.absoluteString!)
        
        let composition = AVMutableComposition()
        
        let compositionTrack1 = composition.addMutableTrackWithMediaType(AVMediaTypeVideo, preferredTrackID: kCMPersistentTrackID_Invalid)
        compositionTrack1.preferredVolume = 1.0
        
        let videoAsset1 = AVURLAsset.init(URL: url1, options: nil)
        
        let trackArray1 = videoAsset1.tracksWithMediaType(AVMediaTypeVideo)
        print(trackArray1)
        let track1 = trackArray1[0]//这里没做异常处理，遇到不支持的格式时数组为空，比如换成ts文件
        let timeRange1 = CMTimeRangeMake(kCMTimeZero, videoAsset1.duration)
        do {
            try compositionTrack1.insertTimeRange(timeRange1, ofTrack: track1, atTime: kCMTimeZero)
            
        } catch {
            print("错误1")
            success = false
        }
        
        
        let videoAsset2 = AVURLAsset.init(URL: url2, options: nil)
        
        let trackArray2 = videoAsset2.tracksWithMediaType(AVMediaTypeVideo)
        print(trackArray2)
        let track2 = trackArray2[0]
        let timeRange2 = CMTimeRangeMake(kCMTimeZero, videoAsset2.duration)
        do {
            try compositionTrack1.insertTimeRange(timeRange2, ofTrack: track2, atTime: kCMTimeZero)
            
        } catch {
            print("错误2")
            success = false
        }
        
        if !success{
            indicator.stopAnimating()
            view.userInteractionEnabled = true
            label.text = "转换失败"
        }
        
        let exportSession = AVAssetExportSession(asset:composition, presetName: AVAssetExportPresetMediumQuality)
        
        if exportSession != nil{
            let temporaryFileName = generateTemporyVideoFile()
            
            exportSession?.outputURL = NSURL(fileURLWithPath: temporaryFileName)
            exportSession?.outputFileType = AVFileTypeMPEG4
            print("开始转换")
            exportSession?.exportAsynchronouslyWithCompletionHandler({ () -> Void in
                //这里非主线程
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.indicator.stopAnimating()
                    self.view.userInteractionEnabled = true
                })
                var tmpString = "转换失败"
                if exportSession?.status == AVAssetExportSessionStatus.Completed{
                    print("输出成功")
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        self.covertVideoFilePath = temporaryFileName
                        self.playVideoButton.userInteractionEnabled = true
                        tmpString = "转换成功 可以播放视频"
                    })

                }else if exportSession?.status == AVAssetExportSessionStatus.Failed{
                    tmpString = "转换失败"
                }else if exportSession?.status == AVAssetExportSessionStatus.Cancelled{
                    tmpString = "任务取消"
                }else if exportSession?.status == AVAssetExportSessionStatus.Exporting{
                    tmpString = "转换ing"
                }else if exportSession?.status == AVAssetExportSessionStatus.Waiting{
                    tmpString = "等待ing"
                }else{
                    tmpString = "未知错误"
                }
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.label.text = tmpString
                })
            })
            
        }
    }
    @IBAction func onClickVovertMP4(){
        print("onClickVovertMP4()")
        onClickCovertTS()
    }
    
    @IBAction func playVideo(){
        print("playVideo()")
        if covertVideoFilePath != nil{
            let url = NSURL.fileURLWithPath(covertVideoFilePath!)
            playerView.playVideoWithURL(url)
        }
    }
}
extension FirstViewController{
    func generateTemporyVideoFile() -> String{
        var temporaryFileName = Resource.document()
        temporaryFileName = temporaryFileName + "/\(NSDate().timeIntervalSince1970)" + ".mp4"
        return temporaryFileName
    }
}
