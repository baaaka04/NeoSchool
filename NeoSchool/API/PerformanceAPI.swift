import Foundation

protocol PerformanceAPIProtocol: AnyObject {
    func getGrades() async throws -> [GradeName]
    func getGradeDayData(gradeId: Int, subjectId: Int, date: Date) async throws -> [FullNameUser]
    func setGradeForLesson(grade: Grade, studentId: Int, subjectId: Int, date: Date) async throws
}

class PerformanceAPI: PerformanceAPIProtocol {

    private let networkAPI = NetworkAPI()

    func getGrades() async throws -> [GradeName] {
        let grades = try await networkAPI.getGrades()
        let newGrades = grades.map { grade in
            return GradeName(id: grade.id, name: grade.name.replacingOccurrences(of: "\"", with: ""), subjects: grade.subjects)
        }
        return newGrades
    }

    func getGradeDayData(gradeId: Int, subjectId: Int, date: Date) async throws -> [FullNameUser] {
        try await networkAPI.getGradeDayData(gradeId: gradeId, subjectId: subjectId, date: date)
    }

    func setGradeForLesson(grade: Grade, studentId: Int, subjectId: Int, date: Date) async throws {
        try await networkAPI.setGradeForLesson(grade: grade, studentId: studentId, subjectId: subjectId, date: date)
    }
}
