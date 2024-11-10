import UIKit

struct NeobisNotificationToPresent {
    let id: Int
    let type: NotificationType
    let text: String
    let isRead: Bool
    let date: String
    let teacherComment: String?
    let subjectId: Int?
    let lessonId: Int?
    let quater: String?
    
    init(notification: NeobisNotification, teacherComment: String? = nil, subjectId: Int? = nil, lessonId: Int? = nil, quater: String? = nil) {
        self.id = notification.id
        self.type = notification.type
        self.text = notification.title
        self.isRead = notification.isRead
        self.subjectId = subjectId
        self.lessonId = lessonId
        self.quater = quater
        self.teacherComment = teacherComment

        guard let formattedDate = try? DateConverter.convertDateStringToDay(from: notification.updatedAt, dateFormat: .long),
              let formattedTime = try? DateConverter.convertDateStringToHoursAndMinutes(from: notification.updatedAt, dateFormat: .long) else {
            self.date = ""
            return
        }
        self.date = formattedDate + " в " + formattedTime
    }
}

enum ExtraData: Decodable {
    case classworkRate(mark: String, subject: String, subjectId: Int)
    case submissionRate(mark: String, subject: String, submissionId: Int, teacherComment: String)
    case homeworkRevise(lesson: Int, student: String)
    case quaterRate(mark: String, subject: String, subjectId: Int, quater: String)
    case homeworkSubmit(student: String, lesson: Int)
}

struct NeobisNotification: Decodable {
    
    let id: Int
    let createdAt: String
    let updatedAt: String
    let sender: Int
    let extraData: ExtraData
    let title: String
    let description: String
    let isRead: Bool
    let type: NotificationType
    
    enum CodingKeys: String, CodingKey {
        case id, sender, title, description, type
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case extraData = "extra_data"
        case isRead = "is_read"
    }

}

enum NotificationType: String, Decodable {
    case rate_homework, rate_classwork, revise_homework, rate_quarter, submit_homework
}

extension NeobisNotification {
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try container.decode(Int.self, forKey: .id)
        createdAt = try container.decode(String.self, forKey: .createdAt)
        updatedAt = try container.decode(String.self, forKey: .updatedAt)
        sender = try container.decode(Int.self, forKey: .sender)
        title = try container.decode(String.self, forKey: .title)
        description = try container.decode(String.self, forKey: .description)
        isRead = try container.decode(Bool.self, forKey: .isRead)
        type = try container.decode(NotificationType.self, forKey: .type)
        
        let extraDataContainer = try container.nestedContainer(keyedBy: ExtraDataCodingKeys.self, forKey: .extraData)
        extraData = try Self.decodeExtraData(from: extraDataContainer, for: type)
    }
    
    private enum ExtraDataCodingKeys: String, CodingKey {
        case mark, subject, lesson, student
        case subjectId = "subject_id"
        case quater = "quarter"
        case submissionId = "submission_id"
        case teacherComment = "teacher_comment"
    }
    
    private static func decodeExtraData(from container: KeyedDecodingContainer<ExtraDataCodingKeys>, for type: NotificationType) throws -> ExtraData {

        switch type {
        case .rate_homework:
            let mark = try container.decode(String.self, forKey: .mark)
            let subject = try container.decode(String.self, forKey: .subject)
            let submissionId = try container.decode(Int.self, forKey: .submissionId)
            let teacherComment = try container.decode(String.self, forKey: .teacherComment)
            return .submissionRate(mark: mark, subject: subject, submissionId: submissionId, teacherComment: teacherComment)
        case .rate_classwork:
            let mark = try container.decode(String.self, forKey: .mark)
            let subject = try container.decode(String.self, forKey: .subject)
            let subjectId = try container.decode(Int.self, forKey: .subjectId)
            return .classworkRate(mark: mark, subject: subject, subjectId: subjectId)
        case .revise_homework:
            let lessonId = try container.decode(Int.self, forKey: .lesson)
            let studentName = try container.decode(String.self, forKey: .student)
            return .homeworkRevise(lesson: lessonId, student: studentName)
        case .rate_quarter:
            let mark = try container.decode(String.self, forKey: .mark)
            let subject = try container.decode(String.self, forKey: .subject)
            let subjectId = try container.decode(Int.self, forKey: .subjectId)
            let quater = try container.decode(String.self, forKey: .quater)
            return .quaterRate(mark: mark, subject: subject, subjectId: subjectId, quater: quater)
        case .submit_homework:
            let studentName = try container.decode(String.self, forKey: .student)
            let lessonId = try container.decode(Int.self, forKey: .lesson)
            return .homeworkSubmit(student: studentName, lesson: lessonId)
        }
        // Add more cases if needed
    }
}

struct DTONotifications: Decodable {
    let totalCount : Int
    let totalPages : Int
    let list : [NeobisNotification]

    enum CodingKeys: String, CodingKey {
        case list
        case totalCount = "total_count"
        case totalPages = "total_pages"
    }
}
