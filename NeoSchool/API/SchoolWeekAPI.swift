import Foundation

protocol SchoolWeekAPIProtocol {
    func getSchoolWeek(userRole: UserRole) async throws -> [SchoolDay]
}

class SchoolWeekAPI: SchoolWeekAPIProtocol {
    let networkAPI = NetworkAPI()

    func getSchoolWeek(userRole: UserRole) async throws -> [SchoolDay] {
        try await networkAPI.loadSchoolWeek(userRole: userRole)
    }
}
