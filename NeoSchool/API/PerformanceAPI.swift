import Foundation

protocol PerformanceAPIProtocol: AnyObject {
    func getGrades() async throws -> [GradeName]
    func getGradeDayData(gradeId: Int, subjectId: Int, date: Date) async throws -> [FullNameUser]
    func getGradeQuaterData(gradeId: Int, subjectId: Int) async throws -> [FullNameUser]
    func setGradeForLesson(grade: Grade, studentId: Int, subjectId: Int, date: Date) async throws
    func setGradeForQuater(grade: Grade, studentId: Int, subjectId: Int, quater: Quater) async throws
    func getLastMarks(quater: String) async throws -> [LastMarks?]
    func getSubjectClassworkLastMarks(quater: String, subjectId: Int) async throws -> [StudentSubjectMark]
    func getSubjectHomeworkLastMarks(quater: String, subjectId: Int) async throws -> [TeacherSubmission]
}

class PerformanceAPI: PerformanceAPIProtocol {
    private let networkAPI = NetworkAPI()

    func getGrades() async throws -> [GradeName] {
        let grades = try await networkAPI.getGrades()
        return grades.map { grade in
            GradeName(id: grade.id, name: grade.name.replacingOccurrences(of: "\"", with: ""), subjects: grade.subjects)
        }
    }

    func getGradeDayData(gradeId: Int, subjectId: Int, date: Date) async throws -> [FullNameUser] {
        try await networkAPI.getGradeDayData(gradeId: gradeId, subjectId: subjectId, date: date)
    }

    func setGradeForLesson(grade: Grade, studentId: Int, subjectId: Int, date: Date) async throws {
        try await networkAPI.setGradeForLesson(grade: grade, studentId: studentId, subjectId: subjectId, date: date)
    }

    func getGradeQuaterData(gradeId: Int, subjectId: Int) async throws -> [FullNameUser] {
        try await networkAPI.getGradeQuaterData(gradeId: gradeId, subjectId: subjectId)
    }

    func setGradeForQuater(grade: Grade, studentId: Int, subjectId: Int, quater: Quater) async throws {
        try await networkAPI.setGradeForQuater(grade: grade, studentId: studentId, subjectId: subjectId, quater: quater)
    }

    func getLastMarks(quater: String) async throws -> [LastMarks?] {
        try await networkAPI.getLastMarks(quater: quater)
    }

    func getSubjectClassworkLastMarks(quater: String, subjectId: Int) async throws -> [StudentSubjectMark] {
        try await networkAPI.getSubjectClassworkLastMarks(quater: quater, subjectId: subjectId)
    }

    func getSubjectHomeworkLastMarks(quater: String, subjectId: Int) async throws -> [TeacherSubmission] {
        try await networkAPI.getSubjectHomeworkLastMarks(quater: quater, subjectId: subjectId)
    }
}
