import Foundation

class NotificationsViewModel {
    
    var networkAPI: NotificationsNetworkAPIProtocol

    var notifications : [NeobisNotificationToPresent] = []

    init(networkAPI: NotificationsNetworkAPIProtocol = NetworkAPI()) {
        self.networkAPI = networkAPI
    }

    func getNotifications(currentPage: Int) async throws -> Int {
        let data: DTONotifications = try await networkAPI.getNotifications(page: currentPage, limit: 15)
        let newNotifications = convertNotifications(notifications: data.list)
        if currentPage > 1 {
            self.notifications.append(contentsOf: newNotifications)
        } else {
            self.notifications = newNotifications
        }
        return data.totalPages
    }

    internal func convertNotifications(notifications: [NeobisNotification]) -> [NeobisNotificationToPresent] {
        return notifications.compactMap { notif -> NeobisNotificationToPresent? in
            if case let .submissionRate(_, _, _, teacherComment, lessonId) = notif.extraData {
                return NeobisNotificationToPresent(notification: notif, teacherComment: teacherComment, lessonId: lessonId)
            }
            else if case let .classworkRate(_, _, subjectId, quater) = notif.extraData {
                return NeobisNotificationToPresent(notification: notif, subjectId: subjectId, quater: quater)
            }
            else if case let .homeworkRevise(_, submissionId, lessonId) = notif.extraData {
                return NeobisNotificationToPresent(notification: notif, lessonId: lessonId, submissionId: submissionId)
            }
            else if case let .quaterRate(_, subject, subjectId, quater) = notif.extraData {
                return NeobisNotificationToPresent(notification: notif, subjectId: subjectId, quater: quater, subject: subject)
            }
            else if case let .homeworkSubmit(studentName, submissionId) = notif.extraData {
                return NeobisNotificationToPresent(notification: notif, submissionId: submissionId, studentName: studentName)
            }
            return nil
        }
    }

    func checkAsRead(notificationId: Int) async throws {
        try await networkAPI.checkAsRead(notificationId: notificationId)
    }

}
