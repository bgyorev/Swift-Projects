//
//  AppDelegate.swift
//  RichPushNotifications
//
//  Created by Bozhidar Gyorev on 14.03.18.
//  Copyright © 2018 Bozhidar Gyorev. All rights reserved.
//

import UIKit
import UserNotifications
import UserNotificationsUI
import SafariServices

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {

	var window: UIWindow?


	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
		// Override point for customization after application launch.
		UNUserNotificationCenter.current().delegate = self
		UNUserNotificationCenter.current().requestAuthorization(options: [.badge, .sound, .alert]) { (granted, error) in
			if granted {
				DispatchQueue.main.async {
					application.registerForRemoteNotifications()
				}
				
				let viewAction = UNNotificationAction(identifier: "viewAction", title: "View", options: [.foreground])
				
				let clickAction = UNNotificationAction(identifier: "clickAction", title: "Click", options: [.foreground])
				
				let clickAction2 = UNNotificationAction(identifier: "clickAction", title: "Click", options: [.foreground])
				let clickAction3 = UNNotificationAction(identifier: "clickAction", title: "Click", options: [.foreground])
				let clickAction4 = UNNotificationAction(identifier: "clickAction", title: "Click", options: [.foreground])
				let clickAction5 = UNNotificationAction(identifier: "clickAction", title: "Click", options: [.foreground])
				
				let newsCategory = UNNotificationCategory(identifier: "newsCategory", actions: [viewAction, clickAction,clickAction2,clickAction3,clickAction4,clickAction5], intentIdentifiers: [], options: [])
			
				let textAction = UNTextInputNotificationAction(identifier: "textAction", title: "Answer the question", options: [.foreground], textInputButtonTitle: "Reply", textInputPlaceholder: "Type here")
				
				let customNotificationCategory = UNNotificationCategory(identifier: "customNotification", actions: [textAction], intentIdentifiers: [], options: [])
				let videoNotificationCategory = UNNotificationCategory(identifier: "videoNotification", actions: [], intentIdentifiers: [], options: [])
				UNUserNotificationCenter.current().setNotificationCategories([newsCategory, customNotificationCategory, videoNotificationCategory])
			}
		}
		
		UIApplication.shared.applicationIconBadgeNumber = 0
		return true
	}

	func applicationWillResignActive(_ application: UIApplication) {
		// Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
		// Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
	}

	func applicationDidEnterBackground(_ application: UIApplication) {
		// Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
		// If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
	}

	func applicationWillEnterForeground(_ application: UIApplication) {
		// Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
	}

	func applicationDidBecomeActive(_ application: UIApplication) {
		// Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
		UIApplication.shared.applicationIconBadgeNumber = 0
	}

	func applicationWillTerminate(_ application: UIApplication) {
		// Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
	}


	func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
		let deviceTokenString = deviceToken.reduce("", {$0 + String(format: "%02X", $1)})
		print(deviceTokenString)
	}
	
	func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
		
	}
	
	func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]) {
		let aps = userInfo["aps"] as! Dictionary<String, Any>
		let alert = aps["alert"] as! Dictionary<String, Any>
		let title = alert["title"] as! String
		let message = alert["body"] as! String
		window?.rootViewController?.showAlert(withTitle: title, message: message)
	}
	
	func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
		let userInfo = response.notification.request.content.userInfo
		let aps = userInfo["aps"] as! [String: Any]
		
		if response.actionIdentifier == "viewAction" {
			let url = URL(string: userInfo["link"] as! String)!
			let safari = SFSafariViewController(url: url)
			window?.rootViewController?.present(safari, animated: true, completion: nil)
		}
		
		completionHandler()
	}
	
}

extension UIViewController {
	func showAlert(withTitle title: String?, message: String?) {
		let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
		let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
		alert.addAction(action)
		present(alert, animated: true, completion: nil)
	}
}

