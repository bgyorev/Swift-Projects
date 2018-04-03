//
//  NotificationService.swift
//  NotificationsExtension
//
//  Created by Bozhidar Gyorev on 14.03.18.
//  Copyright © 2018 Bozhidar Gyorev. All rights reserved.
//

import UserNotifications

class NotificationService: UNNotificationServiceExtension {

    var contentHandler: ((UNNotificationContent) -> Void)?
    var bestAttemptContent: UNMutableNotificationContent?

    override func didReceive(_ request: UNNotificationRequest, withContentHandler contentHandler: @escaping (UNNotificationContent) -> Void) {
        self.contentHandler = contentHandler
        bestAttemptContent = (request.content.mutableCopy() as? UNMutableNotificationContent)
        
        if let bestAttemptContent = bestAttemptContent {
            // Modify the notification content here...
			func save(_ identifier: String, data:Data, options: [AnyHashable: Any]?) -> UNNotificationAttachment? {
//				let directory = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(ProcessInfo.processInfo.globallyUniqueString, isDirectory: true)
				
				let directory = FileManager.default.temporaryDirectory.appendingPathComponent(ProcessInfo.processInfo.globallyUniqueString, isDirectory: true)
				
				do {
					try FileManager.default.createDirectory(at: directory, withIntermediateDirectories: true, attributes: nil)
					let fileURL = directory.appendingPathComponent(identifier)
					try data.write(to: fileURL, options: [])
					return try UNNotificationAttachment.init(identifier: identifier, url: fileURL, options: options)
				} catch {
					print(error)
				}
				
				return nil
			}
			
			func exitGracefully(_ reason: String = "") {
				let bca = request.content.mutableCopy() as? UNMutableNotificationContent
				bca!.title = reason
				contentHandler(bca!)
			}
			
			DispatchQueue.main.async {
				guard let content = (request.content.mutableCopy() as? UNMutableNotificationContent) else {
					return exitGracefully()
				}
				
				let userInfo: [AnyHashable: Any] = request.content.userInfo
				guard let attachmentURL = userInfo["media-url"] as? String else {
					return exitGracefully()
				}
				
				if (content.categoryIdentifier == "rich-apns" || content.categoryIdentifier == "customNotification") {
					
					guard let imageData = try? Data.init(contentsOf: URL(string: attachmentURL)!) else {
						return exitGracefully()
					}
					
					guard let attachment = save("image.png", data: imageData, options: nil) else {
						return exitGracefully()
					}
					
					content.attachments = [attachment]
				} else if (content.categoryIdentifier == "videoNotification") {
					guard let videoData = try? Data.init(contentsOf: URL(string: attachmentURL)!) else {
						return exitGracefully()
					}
					
					guard let attachment = save("video.mp4", data: videoData, options: nil) else {
						return exitGracefully()
					}
					content.attachments = [attachment]
				}
				
				
				contentHandler(content.copy() as! UNNotificationContent)
			}
        }
    }
    
    override func serviceExtensionTimeWillExpire() {
        // Called just before the extension will be terminated by the system.
        // Use this as an opportunity to deliver your "best attempt" at modified content, otherwise the original push payload will be used.
        if let contentHandler = contentHandler, let bestAttemptContent =  bestAttemptContent {
            contentHandler(bestAttemptContent)
        }
    }

}
