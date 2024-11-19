import UIKit

struct TeacherLessonDetail: Codable {
    let id: Int
    let subject: StudentSubject
    let homework: TeacherHomework?
    let submissions: [TeacherSubmission]?
    let grade: GradeName
    let room: Room
    let startTime: String
    let endTime: String
    let studentsCount: Int
}
struct TeacherSubmission: Codable {
    let id: Int
    let student: FullNameUser?
    let homework: HomeworkType
    let submittedDate: String
    let submittedOnTime: Bool
    let mark: Grade?
    let lessonId: Int
}
enum HomeworkType: Codable {
    case id(Int)
    case detailed(Homework)

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let homeworkId = try? container.decode(Int.self) {
            self = .id(homeworkId)
        } else if let detailedHomework = try? container.decode(Homework.self) {
            self = .detailed(detailedHomework)
        } else {
            throw DecodingError.dataCorruptedError(in: container, debugDescription: "Unknown HomeworkType")
        }
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .id(let homeworkId):
            try container.encode(homeworkId)
        case .detailed(let homework):
            try container.encode(homework)
        }
    }
}

struct TeacherHomework: Codable {
    let id: Int
    let text: String
    var deadline: String
    let filesCount: Int
}
struct DTOStudentSubmissionCount: Decodable {
    let totalCount: Int
    let totalPages: Int
    let list: [StudentSubmissionCount]
}
struct StudentSubmissionCount: Codable {
    let id: Int
    let fullName: String
    let firstName: String
    let lastName: String
    let patronymic: String?
    let submissionsCount: Int
}
struct TeacherClassItem {
    let id: Int
    let title: String
    let subtitle: String
    var datetime: String?
    let onTime: Bool

    init(id: Int, title: String, subtitle: String, datetime: String, onTime: Bool) {
        self.id = id
        self.title = title
        self.subtitle = subtitle
        self.datetime = datetime
        self.onTime = onTime
    }
    // init for the list of the grade's students and their submissions
    init(studentSubmission: StudentSubmissionCount) {
        self.id = studentSubmission.id
        self.title = "\(studentSubmission.firstName) \(studentSubmission.lastName)"
        self.subtitle = "Заданий сдано: \(studentSubmission.submissionsCount)"
        self.datetime = nil
        self.onTime = false
    }
    // init for the list of the student's submissions
    init(studentLesson: StudentLesson) {
        self.id = studentLesson.id
        self.title = studentLesson.topic
        self.subtitle = "Оценка: \(studentLesson.mark ?? "-") · Предмет: \(studentLesson.subject.name)"
        self.datetime = studentLesson.submittedDate
        self.onTime = false
    }
    // init for the list of the student's submissions on TeacherLessonDetails screen
    init(submission: TeacherSubmission) {
        self.id = submission.id
        self.title = "\(submission.student?.firstName ?? "") \(submission.student?.lastName ?? "")"
        let submittedOnTimeString = submission.submittedOnTime ? "Прислано в срок" : "Срок сдачи пропущен"
        let markString = "Оценка: \(submission.mark?.rawValue ?? "-")"
        self.subtitle = submittedOnTimeString + " · " + markString
        self.datetime = nil
        self.onTime = submission.submittedOnTime
    }
    // init for the list of the student's classwork marks in ClasworkListViewController
    init(classwork: StudentSubjectMark) {
        self.id = classwork.id
        let day = try? DateConverter.convertDateStringToDayAndMonth(from: classwork.createdAt, dateFormat: .short)
        let time = try? DateConverter.convertDateStringToHoursAndMinutes(from: classwork.createdAt, dateFormat: .short)
        self.title = day ?? ""
        self.subtitle = "Оценка: \(classwork.mark.rawValue)"
        self.datetime = time ?? ""
        self.onTime = false
    }
    // init for the list of the student's homework marks in HomeworkListViewController
    init(homework: TeacherSubmission) {
        self.id = homework.lessonId
        let day = try? DateConverter.convertDateStringToDay(from: homework.submittedDate, dateFormat: .long)
        let time = try? DateConverter.convertDateStringToHoursAndMinutes(from: homework.submittedDate, dateFormat: .long)
        if case .detailed(let homework) = homework.homework {
            self.title = homework.topic
        } else {
            self.title = ""
        }
        self.subtitle = "Оценка: \(homework.mark?.rawValue ?? "-")"
        self.datetime = (day ?? "") + " в " + (time ?? "")
        self.onTime = false
    }
}
struct DTOStudentLessonsList: Decodable {
    let totalCount: Int
    let totalPages: Int
    let list: [StudentLesson]
}
struct StudentLesson: Codable {
    let id: Int
    let student: FullNameUser
    let homework: Int
    var submittedDate: String
    let submittedOnTime: Bool
    let mark: String?
    let lessonId: Int
    let subject: SubjectName
    let topic: String
}
enum DateFormat: String {
    case long = "yyyy-MM-dd'T'HH:mm:ss.SSSXXXXX"
    case short = "yyyy-MM-dd'T'HH:mm:ssXXX"
}
struct DTOTeacherHomeworkFiles: Decodable {
    let totalCount: Int
    let totalPages: Int
    let list: [File]
}
struct TeacherSubmissionDetails: Decodable {
    let id: Int
    let student: FullNameUser
    var homework: TeacherHomework
    let subject: SubjectName
    var submittedDate: String
    let studentComment: String?
    let teacherComment: String?
    let files: [File]
    let submittedOnTime: Bool
    let mark: String?
    let lessonId: Int
    let isRevision: Bool
    let canRevise: Bool
    let canGrade: Bool
    let canChangeMark: Bool
    let topic: String
}

struct DTOTeacherGradesWithSubjects: Codable {
    let totalCount: Int
    let totalPages: Int
    let list: [GradeName]
}

struct DTOStudentsMarks: Codable {
    let totalCount: Int
    let totalPages: Int
    let list: [FullNameUser]
}
struct CommentInfo {
    let selectedStudentName: String
    let selectedQuater: Quater
    let avarageMark: String?
}
