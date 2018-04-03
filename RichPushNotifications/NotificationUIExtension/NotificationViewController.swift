//
//  NotificationViewController.swift
//  NotificationUIExtension
//
//  Created by Bozhidar Gyorev on 14.03.18.
//  Copyright © 2018 Bozhidar Gyorev. All rights reserved.
//

import UIKit
import UserNotifications
import UserNotificationsUI

class NotificationViewController: UIViewController, UNNotificationContentExtension {

	@IBOutlet weak var imageView: UIImageView!
	@IBOutlet weak var titleLabel: UILabel!
	@IBOutlet var label: UILabel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any required interface initialization here.
    }
    
    func didReceive(_ notification: UNNotification) {
		self.titleLabel.text = notification.request.content.title
        self.label?.text = notification.request.content.body
		if notification.request.content.attachments.first!.url.startAccessingSecurityScopedResource() {
			DispatchQueue.main.async {
				let image = UIImage.init(contentsOfFile: notification.request.content.attachments[0].url.relativePath)
				self.imageView.image = image
//				notification.request.content.attachments.first!.url.stopAccessingSecurityScopedResource()
			}
			
		}
		becomeFirstResponder()
		self.inputView?.becomeFirstResponder()
		self.inputAccessoryView?.becomeFirstResponder()
    }
	
	

}
