import Foundation
import UIKit

class NetworkAPI {
    
    // GET-REQUEST
    // ENDPOINT /schedule/student/days/
    func loadStudentWeek() async throws -> [StudentDay] {
        let urlString = "https://neobook.online/neoschool/schedule/student/days/"
        let request = try generateAuthorizedRequest(urlString: urlString)
        let (data, _) = try await URLSession.shared.data(for: request)
        
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        let decodedData : [StudentDay] = try decoder.decode([StudentDay].self, from: data)
        
        return decodedData
    }
    
    // GET-REQUEST
    // ENDPOINT /schedule/student/days/{dayId}/lessons/
    func loadLessons(forDay day: Int) async throws -> [StudentLesson] {
        let urlString = "https://neobook.online/neoschool/schedule/student/days/\(day)/lessons/"
        let request = try generateAuthorizedRequest(urlString: urlString)
        let (data, _) = try await URLSession.shared.data(for: request)
                
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        let decodedData : [StudentLesson] = try decoder.decode([StudentLesson].self, from: data)
        
        return decodedData
    }
    
    // GET-REQUEST
    // ENDPOINT /schedule/teacher/lessons/{lessonID}/
    func loadLesssonDetail(forLesson lesson: Int) async throws -> StudentLessonDetail {
        let urlString = "https://neobook.online/neoschool/schedule/student/lessons/\(lesson)/"
        let request = try generateAuthorizedRequest(urlString: urlString)
        let (data, _) = try await URLSession.shared.data(for: request)
                
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        let decodedData : StudentLessonDetail = try decoder.decode(StudentLessonDetail.self, from: data)
        
        return decodedData
    }
    
    //POST-REQUEST
    //ENDPOINT /schedule/student/homeworks/{homework_id}/submit/
    func uploadFiles(homeworkId: Int, files: [AttachedFile], studentComment: String?) async throws -> Void {
        let urlString = "https://neobook.online/neoschool/schedule/student/homeworks/\(homeworkId)/submit/"
        let boundary = "Boundary-\(UUID().uuidString)"
        var params : [[String : String]]? = nil
        if let studentComment { params = [["student_comment": studentComment]] }
        
        let body = try multipartFormDataBody(boundary: boundary, files: files, parameters: params)
        let request = try generateRequest(boundary: boundary, httpBody: body, urlString: urlString)
        
        let (_, resp) = try await URLSession.shared.data(for: request)
        print(resp)
    }
}



extension NetworkAPI {
    
    private func generateAuthorizedRequest(urlString: String) throws -> URLRequest {
        guard let url = URL(string: urlString) else { throw URLError(.badURL) }
        var request = URLRequest(url: url)
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        return request
    }
    
    private func generateRequest(boundary: String, httpBody: Data, urlString: String) throws -> URLRequest {
        var request = try generateAuthorizedRequest(urlString: urlString)
        request.httpMethod = "POST"
        request.setValue("multipart/form-data; boundary=" + boundary, forHTTPHeaderField: "Content-Type")
        request.httpBody = httpBody
        return request
    }
    
    private func multipartFormDataBody(boundary: String, files: [AttachedFile], parameters: [[String: String]]?) throws -> Data {
        let lineBreak = "\r\n"
        var body = Data()
                        
        for file in files {
            body.append("--\(boundary + lineBreak)")
            body.append("Content-Disposition: form-data; name=\"files\"; filename=\"\(file.name)\"\(lineBreak)")
            body.append("Content-Type: image/jpeg\(lineBreak + lineBreak)")
            guard let image = file.image,
                  let imageData = image.jpegData(compressionQuality: 1.0) else { throw URLError(.cannotCreateFile) }
            body.append(imageData)
            body.append(lineBreak)
        }
        
        if let parameters {
            for param in parameters {
                for (key, value) in param {
                    body.append("--\(boundary + lineBreak)")
                    body.append("Content-Disposition: form-data; name=\"\(key)\"\(lineBreak + lineBreak)")
                    body.append(value)
                    body.append(lineBreak)
                }
            }
        }
        
        body.append("--\(boundary)--\(lineBreak)")
        
        return body
    }
}
