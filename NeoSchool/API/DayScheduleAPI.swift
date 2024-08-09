import UIKit

class DayScheduleAPI: StudentLessonDayProtocol, TeacherLessonDayProtocol, TeachersStudentLessonsProtocol {

    let networkAPI = NetworkAPI()
    
    func getLessons(forDayId dayId: Int, userRole: UserRole) async throws -> [SchoolLesson] {
        return try await networkAPI.loadLessons(forDay: dayId, userRole: userRole)
    }
    
    func getStudentLessonDetail(forLessonId lessonId: Int) async throws -> StudentLessonDetail {
        return try await networkAPI.loadLesssonDetail(forLesson: lessonId, userRole: .student)
    }
    
    func getTeacherLessonDetail(forLessonId lessonId: Int) async throws -> TeacherLessonDetail {
        return try await networkAPI.loadLesssonDetail(forLesson: lessonId, userRole: .teacher)
    }
    
    func uploadFiles(homeworkId: Int, files: [AttachedFile], studentComment: String?) async throws {
        return try await networkAPI.uploadFiles(homeworkId: homeworkId, files: files, studentComment: studentComment)
    }
    
    func cancelSubmission(submissionId: Int) async throws {
        try await networkAPI.cancelSubmission(submissionId: submissionId)
    }
    
    func getStudentList(subjectId: Int, gradeId: Int, page: Int) async throws -> [TeacherClassItem] {

        let studentSubmissionsList = try await networkAPI.getStudentList(subjectId: subjectId, gradeId: gradeId, page: page, limit: 10)
        return studentSubmissionsList.map { TeacherClassItem(studentSubmission: $0) }
    }

    func getStudentLessons(studentId: Int, gradeId: Int, page: Int) async throws -> [TeacherClassItem] {

        let studentLessonsList = try await networkAPI.getStudentLessons(studentId: studentId, gradeId: gradeId, page: page, limit: 10)
        guard let studentLessons = studentLessonsList.lessons else { throw MyError.failDecoding }
        return studentLessons.map { TeacherClassItem(studentLesson: $0) }
    }
}

protocol StudentLessonDayProtocol {
    func getLessons(forDayId dayId: Int, userRole: UserRole) async throws -> [SchoolLesson]
    
    func getStudentLessonDetail(forLessonId lessonId: Int) async throws -> StudentLessonDetail
    
    func uploadFiles(homeworkId: Int, files: [AttachedFile], studentComment: String?) async throws
    
    func cancelSubmission(submissionId: Int) async throws
}

protocol TeacherLessonDayProtocol: TeachersStudentLessonsProtocol {
    func getLessons(forDayId dayId: Int, userRole: UserRole) async throws -> [SchoolLesson]
    
    func getTeacherLessonDetail(forLessonId lessonId: Int) async throws -> TeacherLessonDetail
    
    func getStudentList(subjectId: Int, gradeId: Int, page: Int) async throws -> [TeacherClassItem]
}
protocol TeachersStudentLessonsProtocol {
    func getStudentLessons(studentId: Int, gradeId: Int, page: Int) async throws -> [TeacherClassItem]
}
