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
    let submittedDate : String
    let submittedOnTime : Bool
    let mark : String?
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
    let patronymic: String?
    let submissionsCount: Int
}
struct TeacherClassItem {
    let id: Int
    let title: String
    let subtitle: String
    var datetime: String?

    init(id: Int, title: String, subtitle: String, datetime: String) {
        self.id = id
        self.title = title
        self.subtitle = subtitle
        self.datetime = datetime
    }
    // init for the list of the grade's students and their submissions
    init(studentSubmission: StudentSubmissionCount) {
        self.id = studentSubmission.id
        self.title = "\(studentSubmission.firstName) \(studentSubmission.lastName)"
        self.subtitle = "Заданий сдано: \(studentSubmission.submissionsCount)"
        self.datetime = nil
    }
    // init for the list of the student's submissions
    init(studentLesson: StudentLesson) {
        self.id = studentLesson.id
        self.title = studentLesson.topic
        self.subtitle = "Оценка: \(studentLesson.mark ?? "-") · Предмет: \(studentLesson.subject.name)"
        self.datetime = studentLesson.submittedDate
    }
    // init for the list of the student's submissions on TeacherLessonDetails screen
    init(submission: TeacherSubmission) {
        self.id = submission.id
        self.title = "\(submission.student.firstName) \(submission.student.lastName)"
        let submittedOnTimeString = submission.submittedOnTime ? "Прислано в срок" : "Срок сдачи пропущен"
        let markString = "Оценка: \(submission.mark ?? "-")"
        self.subtitle = submittedOnTimeString + " · " + markString
        self.datetime = nil
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
    var submittedDate : String
    let submittedOnTime : Bool
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
    let totalCount : Int
    let totalPages : Int
    let list : [File]
}
struct TeacherSubmissionDetails: Decodable {
    let id: Int
    let student: FullNameUser
    let homework: TeacherHomework
    let subject: SubjectName
    let submittedDate: String
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
}
