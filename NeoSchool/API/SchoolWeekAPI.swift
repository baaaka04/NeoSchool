import Foundation

class SchoolWeekAPI {
    let networkAPI = NetworkAPI()

    func getSchoolWeek(userRole: UserRole) async throws -> [SchoolDay] {
        try await networkAPI.loadSchoolWeek(userRole: userRole)
    }
}
