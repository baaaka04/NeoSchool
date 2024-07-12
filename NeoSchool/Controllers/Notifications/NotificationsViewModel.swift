import Foundation

protocol NotificationsRefreshable: AnyObject {
    func updateNotifications()
}

class NotificationsViewModel {
    
    weak var view: NotificationsRefreshable?
    private let networkAPI = NetworkAPI()
    
    var notifications : [NeobisNotificationToPresent]?
    var isLoading = false
    var pagesTotal: Int = 1
    var page: Int = 1
    
    func getNotifications() {
        guard page <= pagesTotal, self.notifications == nil else { return }
        self.isLoading = true
        Task {
            do {
                let data = try await networkAPI.getNotifications(page: self.page, limit: 10)
                self.pagesTotal = data.total_pages
                self.notifications = convertNotifications(notifications: data.list)
                DispatchQueue.main.sync {
                    self.view?.updateNotifications()
                }
                self.isLoading = false
                self.page = 2
            } catch { print(error) }
        }
    }
    
    func loadMoreNotifications() {
        guard page <= pagesTotal, let notifications else { return }
        self.isLoading = true
        Task {
            do {
                let data = try await networkAPI.getNotifications(page: self.page, limit: 10)
                self.pagesTotal = data.total_pages
                let newNotifications = convertNotifications(notifications: data.list)
                self.notifications?.append(contentsOf: newNotifications)
                DispatchQueue.main.sync {
                    self.view?.updateNotifications()
                }
                self.isLoading = false
                self.page += 1
            } catch { print(error) }
        }
    }
    
    private func convertNotifications(notifications: [NeobisNotification]) -> [NeobisNotificationToPresent] {
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
            return nil
        }
    }

    
    
}
