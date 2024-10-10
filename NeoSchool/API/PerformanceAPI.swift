import Foundation

protocol PerformanceAPIProtocol: AnyObject {
    func getGrades() async throws -> [GradeName]
    func getGradeDayData(gradeId: Int, subjectId: Int, date: Date) async throws -> [FullNameUser]
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
}
