import Foundation


class PerformanceViewModel: GradesBarVMProtocol {

    private let performanceAPI = PerformanceAPI()

    func getGrades() async throws -> [String] {
        return try await performanceAPI.getGrades()
    }

}
