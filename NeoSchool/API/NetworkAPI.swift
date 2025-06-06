import Foundation
import UIKit

class NetworkAPI: NotificationsNetworkAPIProtocol {
//    private let domen: String = "https://neobook.online"
    private let domen = "http://localhost:8000"

    // GET-REQUEST
    // ENDPOINT /schedule/{userRole}/days/
    func loadSchoolWeek(userRole: UserRole) async throws -> [SchoolDay] {
        let urlString = "\(domen)/neoschool/schedule/\(userRole.rawValue)/days/"
        let request = try generateAuthorizedRequest(urlString: urlString)
        let (data, _) = try await URLSession.shared.data(for: request)

        return try decodeRecievedData(data: data) as [SchoolDay]
    }

    // GET-REQUEST
    // ENDPOINT /schedule/{userRole}/days/{dayId}/lessons/
    func loadLessons(forDay day: Int, userRole: UserRole) async throws -> [SchoolLesson] {
        let urlString = "\(domen)/neoschool/schedule/\(userRole.rawValue)/days/\(day)/lessons/"
        let request = try generateAuthorizedRequest(urlString: urlString)
        let (data, _) = try await URLSession.shared.data(for: request)

        return try decodeRecievedData(data: data) as [SchoolLesson]
    }

    // GET-REQUEST
    // ENDPOINT /schedule/{userRole}/lessons/{lessonID}/
    func loadLesssonDetail<T: Decodable>(forLesson lesson: Int, userRole: UserRole) async throws -> T {
        let urlString = "\(domen)/neoschool/schedule/\(userRole.rawValue)/lessons/\(lesson)/"
        let request = try generateAuthorizedRequest(urlString: urlString)
        let (data, _) = try await URLSession.shared.data(for: request)

        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return try decoder.decode(T.self, from: data) as T
    }

    // POST-REQUEST
    // ENDPOINT /schedule/student/homeworks/{homework_id}/submit/
    func uploadFiles(homeworkId: Int, files: [AttachedFile], studentComment: String?) async throws {
        let urlString = "\(domen)/neoschool/schedule/student/homeworks/\(homeworkId)/submit/"
        let boundary = "Boundary-\(UUID().uuidString)"
        var params: [[String: String]]?
        if let studentComment { params = [["student_comment": studentComment]] }

        let body = try multipartFormDataBody(boundary: boundary, parameters: params, files: files)
        let request = try generateRequest(boundary: boundary, httpBody: body, urlString: urlString)

        let (_, resp) = try await URLSession.shared.data(for: request)

        guard let httpresponse = resp as? HTTPURLResponse, httpresponse.statusCode == 200 else {
            throw MyError.badNetwork
        }
    }

    // DELETE-REQUEST
    // ENDPOINT /schedule/student/homeworks/submissions/{submission_id}/cancel/
    func cancelSubmission(submissionId: Int) async throws {
        let urlString = "\(domen)/neoschool/schedule/student/homeworks/submissions/\(submissionId)/cancel/"
        var request = try generateAuthorizedRequest(urlString: urlString)
        request.httpMethod = "DELETE"
        let (_, resp) = try await URLSession.shared.data(for: request)

        guard let httpresponse = resp as? HTTPURLResponse, httpresponse.statusCode == 204 else {
            throw MyError.badNetwork
        }
    }

    // POST-REUEST
    // ENDPOINT /users/login/refresh/
    func refreshAccessToken(refreshToken token: String) async throws -> Data {
        let urlString = "\(domen)/neoschool/users/login/refresh/"
        guard let url = URL(string: urlString) else { throw URLError(.badURL) }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let tokenJSON: [String: String] = ["refresh": token]
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
        let decodedData: [String: String] = try decoder.decode([String: String].self, from: data)
        guard let accessToken = decodedData["access"] else { throw URLError(.cannotDecodeContentData) }
        return Data(accessToken.utf8)
    }

    // POST-REUEST
    // ENDPOINT /users/login/
    func login(username: String, password: String, isTeacher: Bool) async throws -> (Data, Data) {
        let urlString = "\(domen)/neoschool/users/login/"
        guard let url = URL(string: urlString) else { throw URLError(.badURL) }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let tokenJSON: [String: Any] = [
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
        guard let httpResponse = resp as? HTTPURLResponse else {
            throw MyError.badNetwork
        }
        switch httpResponse.statusCode {
        case 200...299:
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            let decodedData: [String: String] = try decoder.decode([String: String].self, from: data)
            guard let refreshToken = decodedData["refresh"] else { throw URLError(.cannotDecodeContentData) }
            guard let accessToken = decodedData["access"] else { throw URLError(.cannotDecodeContentData) }
            return (Data(refreshToken.utf8), Data(accessToken.utf8))
        case 400...499:
            throw MyError.wrongPassword
        default:
            throw MyError.badNetwork
        }
    }

    // POST-REQUEST
    // ENDPOINT /users/password/reset/
    func sendResetPasswordCode(for email: String) async throws -> Int {
        let urlString = "\(domen)/neoschool/users/password/reset/"
        guard let url = URL(string: urlString) else { throw URLError(.badURL) }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let tokenJSON: [String: Any] = [ "email": email ]
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
        let decodedData: ResetPasswordResponse = try decodeRecievedData(data: data)
        return decodedData.userId
    }

    // POST-REQUEST
    // ENDPOINT /users/{id}/password/verify/
    func checkResetPasswordCode(userId: Int, code: Int) async throws -> Bool {
        let urlString = "\(domen)/neoschool/users/\(userId)/password/verify/"
        guard let url = URL(string: urlString) else { throw URLError(.badURL) }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let tokenJSON: [String: Any] = [ "code": code ]
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
            _ = KeychainHelper.save(key: .accessToken, data: Data(decodedData.access.utf8))
            _ = KeychainHelper.save(key: .refreshToken, data: Data(decodedData.refresh.utf8))
            return true
        } catch {
            return false
        }
    }

    // PUT-REQUEST
    // ENDPOINT /users/password/forgot/
    func updatePassword(with password: String) async throws {
        let urlString = "\(domen)/neoschool/users/password/forgot/"
        var request = try generateAuthorizedRequest(urlString: urlString)
        request.httpMethod = "PUT"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let tokenJSON: [String: Any] = [
            "password": password,
            "confirm_password": password,
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

    // PUT-REQUEST
    // ENDPOINT /users/password/change/
    func changePassword(from currentPassword: String, to newPassword: String) async throws {
        let urlString = "\(domen)/neoschool/users/password/change/"
        var request = try generateAuthorizedRequest(urlString: urlString)
        request.httpMethod = "PUT"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let tokenJSON: [String: Any] = [
            "current_password": currentPassword,
            "password": newPassword,
            "confirm_password": newPassword,
        ]
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: tokenJSON, options: [])
            request.httpBody = jsonData
        } catch {
            throw MyError.cannotEncodeData
        }
        let (_, resp) = try await URLSession.shared.data(for: request)
        guard let httpResponse = resp as? HTTPURLResponse else {
            throw MyError.badNetwork
        }
        switch httpResponse.statusCode {
        case 200:
            return
        case 400...499:
            throw MyError.wrongPassword
        default:
            throw MyError.badNetwork
        }
    }

    // GET-REQUEST
    // ENDPOINT /users/profile/
    func getProfileData() async throws -> UserProfile {
        let urlString = "\(domen)/neoschool/users/profile/"
        let request = try generateAuthorizedRequest(urlString: urlString)
        let (data, _) = try await URLSession.shared.data(for: request)

        return try decodeRecievedData(data: data) as UserProfile
    }

    // GET-REQUEST
    // ENDPOINT /notifications/
    func getNotifications(page: Int, limit: Int) async throws -> DTONotifications {
        let urlString = "\(domen)/neoschool/notifications/?page=\(page)&limit=\(limit)"
        let request = try generateAuthorizedRequest(urlString: urlString)
        let (data, _) = try await URLSession.shared.data(for: request)
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSXXXXX"
        decoder.dateDecodingStrategy = .formatted(formatter)
        return try decoder.decode(DTONotifications.self, from: data)
    }

    // GET-REQUEST
    // ENDPOINT /notifications/{notification_id}/
    func checkAsRead(notificationId: Int) async throws {
        let urlString = "\(domen)/neoschool/notifications/\(notificationId)/"
        let request = try generateAuthorizedRequest(urlString: urlString)
        try await URLSession.shared.data(for: request)
    }

    // GET-REQUEST
    // ENDPOINT /schedule/teacher/grades/{grade_id}/students/
    func getStudentList(subjectId: Int, gradeId: Int, page: Int, limit: Int) async throws -> DTOStudentSubmissionCount {
        let urlString = "\(domen)/neoschool/schedule/teacher/" +
        "grades/\(gradeId)/students/?" +
        "subject=\(subjectId)&" +
        "page=\(page)&" +
        "limit=\(limit)"
        let request = try generateAuthorizedRequest(urlString: urlString)
        let (data, _) = try await URLSession.shared.data(for: request)

        return try decodeRecievedData(data: data) as DTOStudentSubmissionCount
    }

    // GET-REQUEST
    // ENDPOINT /neoschool/schedule/teacher/students/{student_id}/all_submissions/
    func getStudentLessons(studentId: Int, page: Int, limit: Int) async throws -> DTOStudentLessonsList {
        let urlString = "\(domen)/neoschool/schedule/teacher/" +
        "students/\(studentId)/all_submissions/?" +
        "page=\(page)&" +
        "limit=\(limit)"
        let request = try generateAuthorizedRequest(urlString: urlString)
        let (data, _) = try await URLSession.shared.data(for: request)

        return try decodeRecievedData(data: data) as DTOStudentLessonsList
    }

    // PUT-REQUEST
    // ENDPOINT /schedule/teacher/lessons/{lesson_id}/
    func setHomework(lessonId: Int, files: [AttachedFile], topic: String, text: String, deadline: String) async throws -> TeacherLessonDetail {
        let urlString = "\(domen)/neoschool/schedule/teacher/lessons/\(lessonId)/"
        let boundary = "Boundary-\(UUID().uuidString)"
        let formattedDeadline = try convertToISOFormat(dateStr: deadline)
        let params: [[String: String]] = [
            ["topic": topic],
            ["text": text],
            ["deadline": formattedDeadline],
        ]

        let body = try multipartFormDataBody(boundary: boundary, parameters: params, files: files)
        var request = try generateRequest(boundary: boundary, httpBody: body, urlString: urlString)
        request.httpMethod = "PUT"

        let (data, resp) = try await URLSession.shared.data(for: request)
        guard let httpresponse = resp as? HTTPURLResponse, httpresponse.statusCode == 200 else {
            throw MyError.badNetwork
        }

        return try decodeRecievedData(data: data) as TeacherLessonDetail
    }

    // GET-REQUEST
    // ENDPOINT /schedule/teacher/homeworks/{homework_id}/files/
    func getTeacherHomeworkFiles(homeworkId: Int, page: Int, limit: Int) async throws -> [String] {
        let urlString = "\(domen)/neoschool/schedule/teacher/" +
        "homeworks/\(homeworkId)/files/?" +
        "page=\(page)&" +
        "limit=\(limit)"
        let request = try generateAuthorizedRequest(urlString: urlString)
        let (data, _) = try await URLSession.shared.data(for: request)

        let decodedData: DTOTeacherHomeworkFiles = try decodeRecievedData(data: data)
        return decodedData.list.map(\.file)
    }

    // GET-REQUEST
    // ENDPOINT /schedule/teacher/submissions/{submission_id}/
    func getSubmissionDetails(submissionId: Int) async throws -> TeacherSubmissionDetails {
        let urlString = "\(domen)/neoschool/schedule/teacher/submissions/\(submissionId)/"
        let request = try generateAuthorizedRequest(urlString: urlString)
        let (data, _) = try await URLSession.shared.data(for: request)

        return try decodeRecievedData(data: data) as TeacherSubmissionDetails
    }

    // POST-REQUEST
    // ENDPOINT /schedule/teacher/submissions/{submission_id}/revise/
    func reviseSubmission(submissionId: Int) async throws {
        let urlString = "\(domen)/neoschool/schedule/teacher/submissions/\(submissionId)/revise/"
        var request = try generateAuthorizedRequest(urlString: urlString)
        request.httpMethod = "POST"
        let (_, _) = try await URLSession.shared.data(for: request)
    }

    // POST-REQUEST
    // ENDPOINT /schedule/teacher/submissions/{submission_id}/rate/
    func gradeSubmission(submissionId: Int, mark: String, teacherComment: String?, date: String) async throws -> TeacherSubmissionDetails {
        let urlString = "\(domen)/neoschool/schedule/teacher/submissions/\(submissionId)/rate/"
        let params: [String: Any] = [
            "mark": mark,
            "teacher_comment": teacherComment ?? "-",
            "date_time": date,
        ]

        var request = try generateAuthorizedRequest(urlString: urlString)
        request.httpMethod = "POST"
        let jsonData = try JSONSerialization.data(withJSONObject: params, options: [])
        request.httpBody = jsonData
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let (data, response) = try await URLSession.shared.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw MyError.badNetwork
        }

        return try decodeRecievedData(data: data) as TeacherSubmissionDetails
    }

    // GET-REQUEST
    // ENDPOINT /marks/teacher/grades/
    func getGrades() async throws -> [GradeName] {
        let urlString = "\(domen)/neoschool/marks/teacher/grades/"
        let request = try generateAuthorizedRequest(urlString: urlString)
        let (data, _) = try await URLSession.shared.data(for: request)
        let decodedData: DTOTeacherGradesWithSubjects = try decodeRecievedData(data: data)
        return decodedData.list
    }

    // GET-REQUEST
    // ENDPOINT /marks/teacher/grades/{grade_id}/students/
    func getGradeDayData(gradeId: Int, subjectId: Int, date: Date) async throws -> [FullNameUser] {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        formatter.timeZone = TimeZone(secondsFromGMT: 0)

        let dateString = formatter.string(from: date)
        let urlString = "\(domen)/neoschool/marks/teacher/" +
        "grades/\(gradeId)/students/?" +
        "page=1" +
        "&limit=1000" + // TODO: Pagination
        "&date_time=\(dateString)" +// 2024-10-06T15%3A37%3A48.093Z" UTC format
        "&subject=\(subjectId)"
        do {
            let request = try generateAuthorizedRequest(urlString: urlString)
            let (data, _) = try await URLSession.shared.data(for: request)
            let decodedData: DTOStudentsMarks = try decodeRecievedData(data: data)
            return decodedData.list
        } catch {
            print(error)
            throw error
        }
    }

    // POST-REQUEST
    // ENDPOINT /marks/teacher/classwork/rate/
    func setGradeForLesson(grade: Grade, studentId: Int, subjectId: Int, date: Date) async throws {
        let urlString = "\(domen)/neoschool/marks/teacher/classwork/rate/"
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime, .withDashSeparatorInDate, .withColonSeparatorInTime, .withTimeZone]
        formatter.timeZone = TimeZone(secondsFromGMT: 0)

        let dateString = formatter.string(from: date)
        let params: [String: Any] = [
            "student": studentId,
            "subject": subjectId,
            "mark": grade.rawValue,
            "date_time": dateString,
        ]

        var request = try generateAuthorizedRequest(urlString: urlString)
        request.httpMethod = "POST"
        let jsonData = try JSONSerialization.data(withJSONObject: params, options: [])
        request.httpBody = jsonData
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let (_, response) = try await URLSession.shared.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw MyError.badNetwork
        }
    }

    // GET-REQUEST
    // ENDPOINT /marks/teacher/grades/{grade_id}/quarter/students/
    func getGradeQuaterData(gradeId: Int, subjectId: Int) async throws -> [FullNameUser] {
        let urlString = "\(domen)/neoschool/marks/teacher/" +
        "grades/\(gradeId)/quarter/students/?" +
        "page=1" +
        "&limit=1000" + // TODO: Pagination
        "&subject=\(subjectId)"
        do {
            let request = try generateAuthorizedRequest(urlString: urlString)
            let (data, _) = try await URLSession.shared.data(for: request)
            let decodedData: DTOStudentsMarks = try decodeRecievedData(data: data)
            return decodedData.list
        } catch {
            print(error)
            throw error
        }
    }

    // POST-REQUEST
    // ENDPOINT /marks/teacher/quarter/rate/
    func setGradeForQuater(grade: Grade, studentId: Int, subjectId: Int, quater: Quater) async throws {
        let urlString = "\(domen)/neoschool/marks/teacher/quarter/rate/"
        let params: [String: Any] = [
            "student": studentId,
            "subject": subjectId,
            "quarter": quater.rawValue,
            "final_mark": grade.rawValue,
        ]

        var request = try generateAuthorizedRequest(urlString: urlString)
        request.httpMethod = "POST"
        let jsonData = try JSONSerialization.data(withJSONObject: params, options: [])
        request.httpBody = jsonData
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let (_, response) = try await URLSession.shared.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw MyError.badNetwork
        }
    }

    // GET-REQUEST
    // ENDPOINT /marks/student/subjects/marks/
    func getLastMarks(quater: String) async throws -> [LastMarks?] {
        let urlString = "\(domen)/neoschool/marks/student/subjects/marks/?" +
        "page=1" +
        "&limit=1000" + // TODO: Pagination
        "&quarter=\(quater)"
        do {
            let request = try generateAuthorizedRequest(urlString: urlString)
            let (data, _) = try await URLSession.shared.data(for: request)
            let decodedData: DTOLastMarks = try decodeRecievedData(data: data)
            return decodedData.list
        } catch {
            print(error)
            throw error
        }
    }

    // GET-REQUEST
    // ENDPOINT /marks/student/subjects/{subject_id}/classwork/marks/
    func getSubjectClassworkLastMarks(quater: String, subjectId: Int) async throws -> [StudentSubjectMark] {
        let urlString = "\(domen)/neoschool/marks/student/subjects/\(subjectId)/classwork/marks/?" +
        "page=1" +
        "&limit=1000" + // TODO: Pagination
        "&quarter=\(quater)"
        do {
            let request = try generateAuthorizedRequest(urlString: urlString)
            let (data, _) = try await URLSession.shared.data(for: request)
            let decodedData: DTOSubjectClassworkLastMarks = try decodeRecievedData(data: data)
            return decodedData.list
        } catch {
            print(error)
            throw error
        }
    }

    // GET-REQUEST
    // ENDPOINT /marks/student/subjects/{subject_id}/homework/marks/
    func getSubjectHomeworkLastMarks(quater: String, subjectId: Int) async throws -> [TeacherSubmission] {
        let urlString = "\(domen)/neoschool/marks/student/subjects/\(subjectId)/homework/marks/?" +
        "page=1" +
        "&limit=1000" + // TODO: Pagination
        "&quarter=\(quater)"
        do {
            let request = try generateAuthorizedRequest(urlString: urlString)
            let (data, _) = try await URLSession.shared.data(for: request)

            let decodedData: DTOSubjectHomeworkLastMarks = try decodeRecievedData(data: data)
            return decodedData.list
        } catch {
            print(error)
            throw error
        }
    }
}

// MARK: Service functions
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

    private func multipartFormDataBody(boundary: String, parameters: [[String: String]]?, files: [AttachedFile]? = nil) throws -> Data {
        let lineBreak = "\r\n"
        var body = Data()

        if let files {
            for file in files {
                body.append("--\(boundary + lineBreak)")
                body.append("Content-Disposition: form-data; name=\"files\"; filename=\"\(file.name)\"\(lineBreak)")
                body.append("Content-Type: image/jpeg\(lineBreak + lineBreak)")
                guard let image = file.image,
                      let imageData = image.jpegData(compressionQuality: 1.0) else { throw URLError(.cannotCreateFile) }
                body.append(imageData)
                body.append(lineBreak)
            }
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

    private func decodeRecievedData<T: Decodable>(data: Data) throws -> T {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSXXXXX"
        decoder.dateDecodingStrategy = .formatted(formatter)
        return try decoder.decode(T.self, from: data)
    }

    private func convertToISOFormat(dateStr: String) throws -> String {
        let dateFormatter = DateFormatter()

        dateFormatter.dateFormat = "d/M/yy"
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)

        guard let date = dateFormatter.date(from: dateStr) else {
            throw MyError.cannotEncodeData
        }

        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSXXXXX"
        return dateFormatter.string(from: date)
    }
}

protocol NotificationsNetworkAPIProtocol: AnyObject {
    func getNotifications(page: Int, limit: Int) async throws -> DTONotifications
    func checkAsRead(notificationId: Int) async throws
}
