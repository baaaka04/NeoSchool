import Foundation

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
    let id : Int
    let student : FullNameUser
    let homework: Int
    let submittedString : String
    let submittedOnTime : Bool
    let mark : String
    let lessonId: Int
}
struct TeacherHomework: Codable {
    let id: Int
    let text: String
    let deadline: String
    let filesCount: Int
}
struct DTOStudentSubmissionCount: Decodable {
    let totalCount : Int
    let totalPages : Int
    let list : [StudentSubmissionCount]
}
struct StudentSubmissionCount: Codable {
    let id: Int
    let fullName: String
    let firstName: String
    let lastName: String
    let patronymic: String
    let submissionsCount: Int
}
struct TeacherClassItem {
    let id = UUID()
    let title: String
    let subtitle: String
    let datetime: String?

    init(title: String, subtitle: String, datetime: String) {
        self.title = title
        self.subtitle = subtitle
        self.datetime = datetime
    }

    init(studentSubmission: StudentSubmissionCount) {
        self.title = "\(studentSubmission.firstName) \(studentSubmission.lastName)"
        self.subtitle = "Заданий сдано: \(studentSubmission.submissionsCount)"
        self.datetime = nil
    }

    init(studentLesson: StudentLesson) {
        self.title = "test topic"//studentLesson.topic
        self.subtitle = "Оценка: \(studentLesson.mark) · Предмет: test subject"
        self.datetime = studentLesson.submittedDate
    }
}
struct DTOStudentLessonsList: Decodable {
    let totalCount : Int
    let totalPages : Int
    let list : [StudentLesson]
}
struct StudentLesson: Codable {
    let id: Int
    let student: FullNameUser
    let homework: Int
    let submittedDate : String
    let submittedOnTime : String
    let mark: String
    let lessonId: String
}
