import Foundation

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
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        let formattedDate = dateFormatter.string(from: notification.updatedAt)
        dateFormatter.dateFormat = "HH:mm"
        let formattedTime = dateFormatter.string(from: notification.updatedAt)
        
        let dataString = formattedDate + " в " + formattedTime
        self.date = dataString
        self.teacherComment = teacherComment
    }
}

enum ExtraData: Decodable {
    case classworkRate(mark: String, subject: String, subjectId: Int)
    case submissionRate(mark: String, subject: String, submissionId: Int, teacherComment: String)
    case homeworkRevise(lesson: Int, student: String)
    case quaterRate(mark: String, subject: String, subjectId: Int, quater: String)
}

struct NeobisNotification: Decodable {
    
    let id: Int
    let createdAt: Date
    let updatedAt: Date
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
    case rate_homework, rate_classwork, revise_homework, rate_quarter
}

extension NeobisNotification {
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try container.decode(Int.self, forKey: .id)
        createdAt = try container.decode(Date.self, forKey: .createdAt)
        updatedAt = try container.decode(Date.self, forKey: .updatedAt)
        sender = try container.decode(Int.self, forKey: .sender)
        title = try container.decode(String.self, forKey: .title)
        description = try container.decode(String.self, forKey: .description)
        isRead = try container.decode(Bool.self, forKey: .isRead)
        type = try container.decode(NotificationType.self, forKey: .type)
        
        let extraDataContainer = try container.nestedContainer(keyedBy: ExtraDataCodingKeys.self, forKey: .extraData)
        extraData = try Self.decodeExtraData(from: extraDataContainer, for: type)
    }
    
    private enum ExtraDataCodingKeys: String, CodingKey {
        case mark, subject, lesson, student, quater, subjectId = "subject_id"
        case submissionId = "submission_id"
        case teacherComment = "teacher_comment"
    }
    
    private static func decodeExtraData(from container: KeyedDecodingContainer<ExtraDataCodingKeys>, for type: NotificationType) throws -> ExtraData {
        
        let mark = try container.decode(String.self, forKey: .mark)
        let subject = try container.decode(String.self, forKey: .subject)
        
        switch type {
        case .rate_homework:
            let submissionId = try container.decode(Int.self, forKey: .submissionId)
            let teacherComment = try container.decode(String.self, forKey: .teacherComment)
            return .submissionRate(mark: mark, subject: subject, submissionId: submissionId, teacherComment: teacherComment)
        case .rate_classwork:
            let subjectId = try container.decode(Int.self, forKey: .subjectId)
            return .classworkRate(mark: mark, subject: subject, subjectId: subjectId)
        case .revise_homework:
            let lessonId = try container.decode(Int.self, forKey: .lesson)
            let studentName = try container.decode(String.self, forKey: .student)
            return .homeworkRevise(lesson: lessonId, student: studentName)
        case .rate_quarter:
            let subjectId = try container.decode(Int.self, forKey: .subjectId)
            let quater = try container.decode(String.self, forKey: .quater)
            return .quaterRate(mark: mark, subject: subject, subjectId: subjectId, quater: quater)
        }
        // Add more cases if needed
    }
}

struct DTONotifications: Decodable {
    let total_count : Int
    let total_pages : Int
    let list : [NeobisNotification]
}
