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
        self.notifications.append(contentsOf: newNotifications)
        return data.totalPages
    }
    
    internal func convertNotifications(notifications: [NeobisNotification]) -> [NeobisNotificationToPresent] {
        return notifications.compactMap { notif -> NeobisNotificationToPresent? in
            if case let .submissionRate(_, _, _, teacherComment) = notif.extraData {
                return NeobisNotificationToPresent(notification: notif, teacherComment: teacherComment)
            }
            else if case let .classworkRate(_, _, subjectId) = notif.extraData {
                return NeobisNotificationToPresent(notification: notif, subjectId: subjectId)
            }
            else if case let .homeworkRevise(lesson, _) = notif.extraData {
                return NeobisNotificationToPresent(notification: notif, lessonId: lesson)
            }
            else if case let .quaterRate(_, _, subjectId, quater) = notif.extraData {
                return NeobisNotificationToPresent(notification: notif, subjectId: subjectId, quater: quater)
            }
            else if case let .homeworkSubmit(_, lesson) = notif.extraData {
                return NeobisNotificationToPresent(notification: notif, lessonId: lesson)
            }
            return nil
        }
    }

}
