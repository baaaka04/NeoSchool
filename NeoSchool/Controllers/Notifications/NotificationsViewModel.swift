import Foundation

protocol NotificationsRefreshable: AnyObject {
    func updateNotifications()
}

class NotificationsViewModel {
    
    weak var view: NotificationsRefreshable?
    private let networkAPI = NetworkAPI()
    
    var notifications : [NeobisNotificationToPresent] = []
    var isLoading = false
    var pagesTotal: Int = 1
    var page: Int = 1

    func getNotifications() {
        guard page <= pagesTotal, self.notifications.isEmpty else { return }
        self.isLoading = true
        Task {
            do {
                let data = try await networkAPI.getNotifications(page: self.page, limit: 10)
                self.pagesTotal = data.total_pages
                self.notifications = data.list.compactMap { NeobisNotificationToPresent(id: $0.id, text: $0.title, isRead: $0.isRead, date: $0.updatedAt) }
                DispatchQueue.main.sync {
                    self.view?.updateNotifications()
                }
                self.isLoading = false
                self.page = 2
            } catch { print(error) }
        }
    }
    
    func loadMoreNotifications() {
        guard page <= pagesTotal, !self.notifications.isEmpty else { return }
        self.isLoading = true
        Task {
            do {
                let data = try await networkAPI.getNotifications(page: self.page, limit: 10)
                self.pagesTotal = data.total_pages
                let newNotifications = data.list.compactMap { NeobisNotificationToPresent(id: $0.id, text: $0.title, isRead: $0.isRead, date: $0.updatedAt) }
                self.notifications.append(contentsOf: newNotifications)
                DispatchQueue.main.sync {
                    self.view?.updateNotifications()
                }
                self.isLoading = false
                self.page += 1
            } catch { print(error) }
        }
    }
    
    
}
