import UIKit

class DayScheduleAPI {
    
    let networkAPI = NetworkAPI()
    
    func getLessons(forDayId dayId: Int, userRole: UserRole) async throws -> [SchoolLesson] {
        return try await networkAPI.loadLessons(forDay: dayId, userRole: userRole)
    }
    
    func getLessonDetail(forLessonId lessonId: Int) async throws -> StudentLessonDetail {
        return try await networkAPI.loadLesssonDetail(forLesson: lessonId)
    }
    
    func uploadFiles(homeworkId: Int, files: [AttachedFile], studentComment: String?) async throws {
        return try await networkAPI.uploadFiles(homeworkId: homeworkId, files: files, studentComment: studentComment)
    }
    
    func cancelSubmission(submissionId: Int) async throws {
        try await networkAPI.cancelSubmission(submissionId: submissionId)
    }
}

