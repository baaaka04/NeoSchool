import Foundation

class StudentWeekAPI {
    
    let networkAPI = NetworkAPI()
    
    
    func getStudentWeek() async throws -> [StudentDay] {
        
        return try await networkAPI.loadStudentWeek()
    }
    
}
