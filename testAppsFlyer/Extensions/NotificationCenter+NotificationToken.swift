//
//  NotificationCenter+NotificationToken.swift
//  testAppsFlyer
//
//  Created by Анисимов Алексей Викторович on 22.02.2024.
//

import Foundation

/// Convenience object which holds the token to unsubscribe for a Notification.
/// Once this object is deallocated it automatically removes observing.
public final class NotificationToken: NSObject {
    // MARK: - Properties
    let notificationCenter: NotificationCenter
    let token: Any

    // MARK: - (De)Init
    public init(notificationCenter: NotificationCenter = .default, token: Any) {
        self.notificationCenter = notificationCenter
        self.token = token
    }

    deinit {
        notificationCenter.removeObserver(token)
    }
}

extension NotificationCenter {
    /// Convenience wrapper for addObserver(forName:object:queue:using:)
    /// that returns a NotificationToken.
    /// A NotificationToken takes case of removing observer.
    public func observe(
        name: NSNotification.Name?,
        object: Any? = nil,
        queue: OperationQueue? = nil,
        using block: @escaping (Notification) -> Void
    ) -> NotificationToken {
        let token = addObserver(forName: name, object: object, queue: queue, using: block)
        return NotificationToken(notificationCenter: self, token: token)
    }

    /// Convenience wrapper for addObserver(forName:object:queue:using:)
    /// that returns a NotificationToken.
    /// A NotificationToken takes case of removing observer.
    public func observe(
        name: NSNotification.Name?,
        object: Any? = nil,
        queue: OperationQueue? = nil,
        using block: @escaping () -> Void
    ) -> NotificationToken {
        let token = addObserver(forName: name, object: object, queue: queue) { _ in
            block()
        }
        return NotificationToken(notificationCenter: self, token: token)
    }
}
