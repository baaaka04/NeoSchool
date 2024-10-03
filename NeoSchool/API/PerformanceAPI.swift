import Foundation

class PerformanceAPI {

    private let networkAPI = NetworkAPI()

    func getGrades() async throws -> [String] {
        let grades = try await networkAPI.getGrades()
        return grades.map { $0.name.replacingOccurrences(of: "\"", with: "")  }
    }
}
