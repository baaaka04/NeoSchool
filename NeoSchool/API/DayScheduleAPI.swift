import Foundation

class DayScheduleAPI {
    
    let networkAPI = NetworkAPI()
    
    func getLessons(forDayId dayId: Int) async throws -> [StudentLesson] {

        return try await networkAPI.loadLessons(forDay: dayId)        
    }
}

