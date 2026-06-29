import Foundation
import UserNotifications

// MARK: - Protocol

protocol NotificationPermissionServiceProtocol {
    func requestPermission() async -> Bool
    func currentStatus() async -> UNAuthorizationStatus
}

// MARK: - Implementation

final class NotificationPermissionService: NotificationPermissionServiceProtocol {
    func requestPermission() async -> Bool {
        do {
            return try await UNUserNotificationCenter.current()
                .requestAuthorization(options: [.alert, .badge, .sound])
        } catch {
            return false
        }
    }

    func currentStatus() async -> UNAuthorizationStatus {
        let settings = await UNUserNotificationCenter.current().notificationSettings()
        return settings.authorizationStatus
    }
}
