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
        
        guard let httpresponse = resp as? HTTPURLResponse, httpresponse.statusCode == 200 else {
            throw MyError.badNetwork
        }
    }
    
    //DELETE-REQUEST
    //ENDPOINT /schedule/student/homeworks/submissions/{submission_id}/cancel/
    func cancelSubmission(submissionId: Int) async throws -> Void {
        let urlString = "https://neobook.online/neoschool/schedule/student/homeworks/submissions/\(submissionId)/cancel/"
        var request = try generateAuthorizedRequest(urlString: urlString)
        request.httpMethod = "DELETE"
        let (_, resp) = try await URLSession.shared.data(for: request)
        
        guard let httpresponse = resp as? HTTPURLResponse, httpresponse.statusCode == 204 else {
            throw MyError.badNetwork
        }
    }
    
    //POST-REUEST
    //ENDPOINT /users/login/refresh/
    func refreshAccessToken(refreshToken token: String) async throws -> Data {
        let urlString = "https://neobook.online/neoschool/users/login/refresh/"
        guard let url = URL(string: urlString) else { throw URLError(.badURL) }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let tokenJSON : [String: String] = ["refresh": token]
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: tokenJSON, options: [])
            request.httpBody = jsonData
        } catch {
            throw MyError.cannotEncodeData
        }
        let (data, resp) = try await URLSession.shared.data(for: request)
        guard let httpresponse = resp as? HTTPURLResponse, httpresponse.statusCode == 200 else {
            throw MyError.badNetwork
        }
                
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        let decodedData : [String: String] = try decoder.decode([String: String].self, from: data)
        guard let accessToken = decodedData["access"] else { throw URLError(.cannotDecodeContentData) }
        return Data(accessToken.utf8)
    }
    
    //POST-REUEST
    //ENDPOINT /users/login/
    func login(username: String, password: String, isTeacher: Bool) async throws -> (Data, Data) {
        let urlString = "https://neobook.online/neoschool/users/login/"
        guard let url = URL(string: urlString) else { throw URLError(.badURL) }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let tokenJSON : [String: Any] = [
            "username": username,
            "password": password,
            "is_teacher": isTeacher,
        ]
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: tokenJSON, options: [])
            request.httpBody = jsonData
        } catch {
            throw MyError.cannotEncodeData
        }
        let (data, resp) = try await URLSession.shared.data(for: request)
        guard let httpresponse = resp as? HTTPURLResponse, httpresponse.statusCode == 200 else {
            throw MyError.badNetwork
        }
                
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        let decodedData : [String: String] = try decoder.decode([String: String].self, from: data)
        guard let refreshToken = decodedData["refresh"] else { throw URLError(.cannotDecodeContentData) }
        guard let accessToken = decodedData["access"] else { throw URLError(.cannotDecodeContentData) }
        return (Data(refreshToken.utf8), Data(accessToken.utf8))
    }
    
    //POST-REQUEST
    //ENDPOINT /users/password/reset/
    func sendResetPasswordCode(for email: String) async throws -> Int {
        let urlString = "https://neobook.online/neoschool/users/password/reset/"
        guard let url = URL(string: urlString) else { throw URLError(.badURL) }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let tokenJSON : [String: Any] = [ "email": email ]
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: tokenJSON, options: [])
            request.httpBody = jsonData
        } catch {
            throw MyError.cannotEncodeData
        }
        let (data, resp) = try await URLSession.shared.data(for: request)
        guard let httpresponse = resp as? HTTPURLResponse, httpresponse.statusCode == 200 else {
            throw MyError.badNetwork
        }
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        let decodedData = try decoder.decode(ResetPasswordResponse.self, from: data)
        return decodedData.userId
    }
    
    //POST-REQUEST
    //ENDPOINT /users/{id}/password/verify/
    func checkResetPasswordCode(userId: Int, code: Int) async throws -> Bool {
        let urlString = "https://neobook.online/neoschool/users/\(userId)/password/verify/"
        guard let url = URL(string: urlString) else { throw URLError(.badURL) }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let tokenJSON : [String: Any] = [ "code": code ]
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: tokenJSON, options: [])
            request.httpBody = jsonData
        } catch {
            throw MyError.cannotEncodeData
        }
        let (data, resp) = try await URLSession.shared.data(for: request)
        guard let httpresponse = resp as? HTTPURLResponse, httpresponse.statusCode == 200 else { return false }
        do {
            let decodedData = try JSONDecoder().decode(VerifyPasswordResponse.self, from: data)
            KeychainHelper.save(key: .accessToken, data: Data(decodedData.access.utf8))
            KeychainHelper.save(key: .refreshToken, data: Data(decodedData.refresh.utf8))
            return true
        } catch {
            return false
        }
    }
    
    //PUT-REQUEST
    //ENDPOINT /users/password/forgot/
    func updatePassword(with password: String) async throws -> Void {
        let urlString = "https://neobook.online/neoschool/users/password/forgot/"
        var request = try generateAuthorizedRequest(urlString: urlString)
        request.httpMethod = "PUT"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let tokenJSON : [String: Any] = [ 
            "password": password,
            "confirm_password": password
        ]
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: tokenJSON, options: [])
            request.httpBody = jsonData
        } catch {
            throw MyError.cannotEncodeData
        }
        let (_, resp) = try await URLSession.shared.data(for: request)
        guard let httpresponse = resp as? HTTPURLResponse, httpresponse.statusCode == 200 else {
            throw MyError.badNetwork
        }
    }
    
    // GET-REQUEST
    // ENDPOINT /users/profile/
    func getProfileData() async throws -> UserProfile {
        let urlString = "https://neobook.online/neoschool/users/profile/"
        let request = try generateAuthorizedRequest(urlString: urlString)
        let (data, _) = try await URLSession.shared.data(for: request)
                
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        let decodedData : UserProfile = try decoder.decode(UserProfile.self, from: data)

        return decodedData
    }
    
}


//MARK: Generate request with files
extension NetworkAPI {
    
    private func generateAuthorizedRequest(urlString: String) throws -> URLRequest {
        guard let url = URL(string: urlString) else { throw URLError(.badURL) }
        var request = URLRequest(url: url)
        guard let tokenData = KeychainHelper.load(key: .accessToken) else { throw MyError.noAccessToken}
        guard let token = String(data: tokenData, encoding: .utf8) else {throw MyError.failDecoding} 
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
