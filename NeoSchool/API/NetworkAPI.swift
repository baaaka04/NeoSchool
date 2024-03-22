import Foundation


class NetworkAPI {
    
    // GET-REQUEST
    // ENDPOINT /schedule/student/days/
    func loadStudentWeek() async throws -> [StudentDay] {
        guard let url = URL(string: "https://neobook.online/neoschool/schedule/student/days/") else {
            throw URLError(.badURL)
        }
        var request = URLRequest(url: url)
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        let (data, _) = try await URLSession.shared.data(for: request)
        
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        let decodedData : [StudentDay] = try decoder.decode([StudentDay].self, from: data)
        
        return decodedData
    }
    
    // GET-REQUEST
    // ENDPOINT /schedule/student/days/{dayId}/lessons/
    func loadLessons(forDay day: Int) async throws -> [StudentLesson] {
        
        let URLstirng = "https://neobook.online/neoschool/schedule/student/days/\(day)/lessons/"
        guard let url = URL(string: URLstirng) else {
            throw URLError(.badURL)
        }
        var request = URLRequest(url: url)
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        let (data, _) = try await URLSession.shared.data(for: request)
                
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        let decodedData : [StudentLesson] = try decoder.decode([StudentLesson].self, from: data)
        
        return decodedData
    }
    
    // GET-REQUEST
    // ENDPOINT /schedule/teacher/lessons/{lessonID}/
    func loadLesssonDetail(forLesson lesson: Int) async throws -> StudentLessonDetail {
        let URLstirng = "https://neobook.online/neoschool/schedule/student/lessons/\(lesson)/"
        
        guard let url = URL(string: URLstirng) else {
            throw URLError(.badURL)
        }
        var request = URLRequest(url: url)
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        let (data, _) = try await URLSession.shared.data(for: request)
                
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        let decodedData : StudentLessonDetail = try decoder.decode(StudentLessonDetail.self, from: data)
        
        return decodedData
    }
    
}
