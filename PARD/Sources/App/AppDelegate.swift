//
//  AppDelegate.swift
//  PARD
//
//  Created by 김하람 on 3/2/24.
//

import UIKit
import GoogleSignIn
import UserNotifications
import FirebaseCore
import FirebaseMessaging

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Firebase 초기화
        FirebaseApp.configure()
        Messaging.messaging().delegate = self
        
        // Google Sign In 설정
        GIDSignIn.sharedInstance.restorePreviousSignIn { user, error in
            if error != nil || user == nil {
                // 로그인이 안된 상태
            } else {
                // 로그인이 된 상태
            }
        }
        
        // 푸시 알림 권한 요청
        UNUserNotificationCenter.current().delegate = self
        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter.current().requestAuthorization(options: authOptions) { granted, error in
            if granted {
                print("✅ Push notification permission granted")
                // 권한이 허용되면 현재 설정 확인
                UNUserNotificationCenter.current().getNotificationSettings { settings in
                    print("🔔 Notification settings: \(settings)")
                }
            } else if let error = error {
                print("🚨 Push notification permission error: \(error)")
            }
        }
        
        // APNs 등록
        application.registerForRemoteNotifications()
        print("📱 Registering for remote notifications...")
        
        return true
    }
    
    // APNs 토큰을 받았을 때 호출되는 메서드
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let tokenParts = deviceToken.map { data in String(format: "%02.2hhx", data) }
        let token = tokenParts.joined()
        print("✅ APNs Device Token: \(token)")
        UserDefaults.standard.set(token, forKey: "deviceToken")
        
        // FCM에 APNs 토큰 등록
        Messaging.messaging().apnsToken = deviceToken
        
        // 토큰이 서버에 제대로 전송되었는지 확인
        if let savedToken = UserDefaults.standard.string(forKey: "deviceToken") {
            print("💾 Saved device token: \(savedToken)")
        }
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Failed to register for remote notifications: \(error)")
    }
}

// MARK: - UNUserNotificationCenterDelegate
extension AppDelegate: UNUserNotificationCenterDelegate {
    // 앱이 포그라운드에 있을 때 알림을 받았을 때 처리
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification,
        withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void
    ) {
        let userInfo = notification.request.content.userInfo
        print("📬 Received notification while app is in foreground: \(userInfo)")
        completionHandler([.banner, .sound, .badge])
    }
    
    // 사용자가 알림을 탭했을 때 처리
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        didReceive response: UNNotificationResponse,
        withCompletionHandler completionHandler: @escaping () -> Void
    ) {
        let userInfo = response.notification.request.content.userInfo
        print("👆 User tapped on notification: \(userInfo)")
        completionHandler()
    }
}

// FCM 델리게이트 추가
extension AppDelegate: MessagingDelegate {
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        print("✉️ Firebase registration token: \(String(describing: fcmToken))")
        
        // FCM 토큰을 서버에 전송
        if let token = fcmToken {
            UserDefaults.standard.set(token, forKey: "fcmToken")
            print("✅ FCM Token saved: \(token)")
            // 이 토큰을 서버에 전송하는 로직 추가
        } else {
            print("🚨 FCM Token is nil")
        }
    }
}

