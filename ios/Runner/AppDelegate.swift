import UIKit
import Flutter
import flutter_local_notifications
import UserNotifications

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {

          // Set up Flutter local notifications
          FlutterLocalNotificationsPlugin.setPluginRegistrantCallback { registry in
              GeneratedPluginRegistrant.register(with: registry)
          }

          // Request notification permissions
          if #available(iOS 10.0, *) {
              UNUserNotificationCenter.current().delegate = self
              let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
              UNUserNotificationCenter.current().requestAuthorization(
                  options: authOptions,
                  completionHandler: { _, _ in }
              )
          } else
          {
              let settings: UIUserNotificationSettings =
                  UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
              application.registerUserNotificationSettings(settings)
          }

    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  // Handle notification tap
      override func userNotificationCenter(
          _ center: UNUserNotificationCenter,
          didReceive response: UNNotificationResponse,
          withCompletionHandler completionHandler: @escaping () -> Void
      ) {
          let userInfo = response.notification.request.content.userInfo
          // Handle the notification data if needed
          completionHandler()
      }

}
