//
//  NotificationManager.swift
//  MiniFlix
//
//  Created by Tuong Vi on 23/7/26.
//

import Foundation
import UserNotifications
import UIKit

@Observable
class NotificationManager: NSObject, UNUserNotificationCenterDelegate{
    static let shared = NotificationManager()
    
    var showSettingAlert: Bool = false
    var selectedMovieId: Int? = nil
    
    private override init() {
        super.init()
        UNUserNotificationCenter.current().delegate = self
    }
    
    func requestAuthorization(){
        let center = UNUserNotificationCenter.current()
        center.getNotificationSettings(){settings in
            DispatchQueue.main.async {
                switch settings.authorizationStatus {
                case .notDetermined:
                    center.requestAuthorization(options: [.alert, .sound, .badge]) { grated, error in
                        if grated {
                            print("Đã cấp quyền thông báo")
                        } else {
                            print("đã từ chối cấp quyền thông báo")
                        }
                    }
                case .denied:
                    self.showSettingAlert = true
                    print("Đã bị từ chối trước đó")
                    
                case.authorized:
                    print ("Đã cấp qquyền trước đó rồi")
                    
                default:
                    break
                }
            }
        }
    }
    
    func oppenAppSettings(){
        if let url = URL(string: UIApplication.openSettingsURLString){
            UIApplication.shared.open(url)
        }
    }
    
    func scheduleLocalNotification (title: String, body: String, timeInterval: TimeInterval, movieId: Int? = nil ){
        let center = UNUserNotificationCenter.current()
        
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = .default
        
        if let movieId = movieId{
            content.userInfo = ["movieId": movieId]
        }
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: timeInterval, repeats: false)
        
        let identifier = "movie_reminder_\(Date().timeIntervalSince1970)"
        
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        
        center.add(request){error in
            if let error = error{
                print("Lỗi lên lịch thông báo \(error.localizedDescription)")
            } else {
                print("Thành công lên lịch thông báo")
            }
            
        }
    }
    
    
    func scheduleCalendarNotification(
        title: String,
        body: String,
        hour: Int,
        minute: Int,
        movieId: Int? = nil,
        repeats: Bool = true
    ) {
        let center = UNUserNotificationCenter.current()
        
       
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = .default
        content.userInfo = ["movieId": movieId]
        
        var dateComponents = DateComponents()
        dateComponents.hour = hour
        dateComponents.minute = minute
        
       
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: repeats)
        
     
        let identifier = "hour_movie_reminder_\(movieId)"
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        
        center.add(request) { error in
            if let error = error {
                print("Lỗi đặt lịch theo giờ: \(error.localizedDescription)")
            } else {
                print("Đã đặt lịch nhắc phim ID: \(movieId) vào lúc \(hour):\(minute) hằng ngày!")
            }
        }
    }
    
    func userNotificationCenter(
            _ center: UNUserNotificationCenter,
            willPresent notification: UNNotification,
            withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void
        ) {
            completionHandler([.banner, .sound, .badge])
        }
        
        
        func userNotificationCenter(
            _ center: UNUserNotificationCenter,
            didReceive response: UNNotificationResponse,
            withCompletionHandler completionHandler: @escaping () -> Void
        ) {
            let userInfo = response.notification.request.content.userInfo
            
            if let movieId = userInfo["movieId"] as? Int {
                DispatchQueue.main.async {
                    print(" Người dùng bấm Noti -> Mở phim có ID: \(movieId)")
                    self.selectedMovieId = movieId
                }
            }
            
            completionHandler()
        }
}
