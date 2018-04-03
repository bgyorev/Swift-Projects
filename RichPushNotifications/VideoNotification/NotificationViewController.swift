//
//  NotificationViewController.swift
//  VideoNotification
//
//  Created by Bozhidar Gyorev on 21.03.18.
//  Copyright © 2018 Bozhidar Gyorev. All rights reserved.
//

import UIKit
import UserNotifications
import UserNotificationsUI
import AVFoundation

class NotificationViewController: UIViewController, UNNotificationContentExtension {

	
	@IBOutlet weak var playerContainer: UIView!
	var videoPlayer: AVPlayer?
	
	var mediaPlayPauseButtonFrame: CGRect {
		return CGRect(x: self.view.center.x - 50, y: self.view.center.y - 50, width: 100, height: 100)
	}
	
	var mediaPlayPauseButtonTintColor: UIColor {
		return .white
	}
	
	var mediaPlayPauseButtonType: UNNotificationContentExtensionMediaPlayPauseButtonType {
		return .overlay
	}
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any required interface initialization here.
    }
    
    func didReceive(_ notification: UNNotification) {
		guard let attachment = notification.request.content.attachments.first else {
			return
		}
		
		if attachment.url.startAccessingSecurityScopedResource() {
			videoPlayer = AVPlayer(url: attachment.url)
			attachment.url.stopAccessingSecurityScopedResource()
		}
		
		let playerLayer = AVPlayerLayer(player: videoPlayer!)
		playerLayer.frame = self.playerContainer.bounds
		playerLayer.videoGravity = .resizeAspectFill
		self.playerContainer.layer.addSublayer(playerLayer)
		
		NotificationCenter.default.addObserver(self, selector: #selector(seekToBegining), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: videoPlayer?.currentItem)
		
    }
	
	func mediaPlay() {
		self.videoPlayer?.play()
	}

	func mediaPause() {
		self.videoPlayer?.pause()
	}
	
	@objc
	func seekToBegining() {
		self.videoPlayer?.seek(to: kCMTimeZero)
		self.extensionContext?.mediaPlayingPaused()
	}
	
}
