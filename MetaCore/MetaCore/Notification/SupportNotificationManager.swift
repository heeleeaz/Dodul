//
//  NotificationService.swift
//  MetaCore
//
//  Created by Elias on 10/05/2020.
//  Copyright © 2020 Elias Igbalajobi. All rights reserved.
//

import AppKit
import UserNotifications

public class SupportNotificationManager{
    public static func shedule(_ content: Content, _ completionHandler: @escaping (Error?)->Void){
        let notification = NSUserNotification()
        
        notification.identifier = content.id
        notification.title = content.title
        notification.informativeText = content.message
        
        if let actionString = content.actionString{
            notification.hasActionButton = true
            notification.actionButtonTitle = actionString
        }
        
        notification.deliveryDate = Date(timeIntervalSinceNow: content.timeInterval)
        notification.soundName = NSUserNotificationDefaultSoundName
        
        NSUserNotificationCenter.default.scheduleNotification(notification)
        completionHandler(nil)
    }
    
    @available(OSX 10.14, *)
    public static func sheduleV14(center: UNUserNotificationCenter, _ content: Content, _ completionHandler: @escaping (Error?)->Void){
        center.requestAuthorization(options: [.alert, .sound]) { granted, error in
            let notificationContent = UNMutableNotificationContent()
            notificationContent.title = content.title
            notificationContent.body = content.message
            notificationContent.sound = UNNotificationSound.default
            
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: content.timeInterval, repeats: false)
            let request = UNNotificationRequest(identifier: content.id, content: notificationContent, trigger: trigger)
            
            if let actionString = content.actionString{
                let defAction = UNNotificationAction(identifier: "defAction", title: actionString, options: .foreground)
                let category = UNNotificationCategory(identifier: "defCategory", actions: [defAction], intentIdentifiers: [])
                center.setNotificationCategories([category])
            }
            
            center.add(request){completionHandler($0)}
        }
    }
    
    public class Content{
        public var id: String!
        public var title: String!
        public var message: String!
        public var timeInterval: TimeInterval = 1
        public var actionString: String?
        
        public init(_ id: String = UUID().uuidString){self.id = id}
    }
}
