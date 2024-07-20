import Foundation

class SchoolWeekAPI {
    
    let networkAPI = NetworkAPI()
    
    
    func getSchoolWeek(userRole: UserRole) async throws -> [SchoolDay] {
        return try await networkAPI.loadSchoolWeek(userRole: userRole)
    }
    
}
