import Foundation

class DayScheduleAPI {
    
    let networkAPI = NetworkAPI()
    
    func getLessons(forDayId dayId: Int) async throws -> [StudentLesson] {

        return try await networkAPI.loadLessons(forDay: dayId)        
    }
    
    func getLessonDetail(forLessonId lessonId: Int) async throws -> StudentLessonDetail {
        return try await networkAPI.loadLesssonDetail(forLesson: lessonId)
    }
}

