//
//  AppDelegate.swift
//  BasicMemo
//
//  Created by 신동희 on 2022/08/31.
//

import UIKit

import IQKeyboardManagerSwift
import FirebaseCore
import FirebaseMessaging
import RealmSwift


@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.enableAutoToolbar = false
        IQKeyboardManager.shared.shouldResignOnTouchOutside = true
        
        
        // Realm Migration
        realmMigration()
        
        
        // Firebase 초기화
        FirebaseApp.configure()
        
        
        
        // 원격 알림 시스템에 앱을 등록
        if #available(iOS 10.0, *) {
            // For iOS 10 display notification (sent via APNS)
            UNUserNotificationCenter.current().delegate = self
            
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: { _, _ in }
            )
        } else {
            let settings: UIUserNotificationSettings =
            UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }
        
        // APNs 등록
        application.registerForRemoteNotifications()

        
        
        // 메시지 대리자 설정
        Messaging.messaging().delegate = self
        
        
        
        // 현재 등록된 토큰 가져오기
        Messaging.messaging().token { token, error in
          if let error = error {
            print("Error fetching FCM registration token: \(error)")
          } else if let token = token {
            print("FCM registration token: \(token)")
          }
        }
        
        
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}




// MARK: - Realm Migration
extension AppDelegate {
    
    func realmMigration() {
        
        let config = Realm.Configuration(schemaVersion: 11) { migration, oldSchemaVersion in
            
            if oldSchemaVersion < 1 {}  // 컬럼 추가
            
            if oldSchemaVersion < 2 {}  // 컬럼 삭제
            
            if oldSchemaVersion < 3 {   // isSetPin 컬럼을 Bool에서 Int로 타입 변환
                migration.enumerateObjects(ofType: Memo.className()) { oldObject, newObject in
                    guard let new = newObject else { return }
                    guard let old = oldObject else { return }
                    
                    new["isSetPin"] = ((old["isSetPin"] as? Bool) ?? false) ? 1 : 0
                }
            }
            
            if oldSchemaVersion < 4 {   // isSetPin의 타입 원상복구
                migration.enumerateObjects(ofType: Memo.className()) { oldObject, newObject in
                    guard let new = newObject else { return }
                    guard let old = oldObject else { return }
                    
                    new["isSetPin"] = ((old["isSetPin"] as? Int) ?? 0) == 0 ? false : true
                }
            }
            
            if oldSchemaVersion < 5 {}  // 컬럼 추가
            
            if oldSchemaVersion < 6 {   // 컬럼 추가 (기본값 임의 설정)
                migration.enumerateObjects(ofType: Memo.className()) { _, newObject in
                    guard let new = newObject else { return }
                    
                    new["test2"] = 7.7
                }
            }
            
            if oldSchemaVersion < 7 {   // 컬럼 추가 (기존 컬럼 데이터를 사용하여 값 할당)
                migration.enumerateObjects(ofType: Memo.className()) { oldObject, newObject in
                    guard let new = newObject else { return }
                    guard let old = oldObject else { return }
                    
                    new["mixValue"] = (old["test"] as? Double ?? 0) + (old["test2"] as? Double ?? 0)
                }
            }
            
            if oldSchemaVersion < 8 {   // 컬럼 이름 변경
                migration.renameProperty(onType: Memo.className(), from: "savedDate", to: "memoDate")
            }
            
            if oldSchemaVersion < 9 { }  // 불필요한 컬럼 삭제
            
            if oldSchemaVersion < 10 { }  // Folder Table 생성 (Realm List Test)
            
            if oldSchemaVersion < 11 { }  // Embedded Object Test
        }
        
        Realm.Configuration.defaultConfiguration = config
        
    }
    
}




// MARK: - UNUserNotification
extension AppDelegate: UNUserNotificationCenterDelegate {
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Messaging.messaging().apnsToken = deviceToken
    }
    
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        // .banner, .list: iOS 14+
        completionHandler([.badge, .sound, .banner, .list])
        
    }
    
    
    // 푸시 클릭: ex. 호두과자 장바구니에 담는 화면까지 넘어가는...
    // 유저가 푸시를 클릭했을 때에만 수신 확인 가능 (잘 보내졌는지? 확인하는건 불가능)
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        print("Body: \(response.notification.request.content.body)")
        print("userInfo: \(response.notification.request.content.userInfo)")
        
        // [AnyHashable : Any]
        let userInfo = response.notification.request.content.userInfo
        
        if userInfo[AnyHashable("sesac")] as? String == "project" {
            print("SESAC PROJECT")
        }else {
            print("NOTHING")
        }
    }
}




// MARK: - MessagingDelegate
extension AppDelegate: MessagingDelegate {
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        print("Firebase registration token: \(String(describing: fcmToken))")
        
        let dataDict: [String: String] = ["token": fcmToken ?? ""]
        NotificationCenter.default.post(
            name: Notification.Name("FCMToken"),
            object: nil,
            userInfo: dataDict
        )
        // TODO: If necessary send token to application server.
        // Note: This callback is fired at each app startup and whenever a new token is generated.
    }
}
