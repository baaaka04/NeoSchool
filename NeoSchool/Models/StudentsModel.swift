import Foundation
import UIKit

// MARK: Student's lesson in the list of subjects
struct StudentLesson: Codable {
    let id : Int
    let day : Day
    let room : Room
    let subject : SubjectName
    let homework : Homework?
    let startTime : String
    let endTime : String
    let mark : String?
}
struct Day: Codable {
    let id : Int
    let name : String
}
struct Room: Codable {
    let id : Int
    let name : String
}
struct SubjectName: Codable {
    let id : Int
    let name : String
}
struct Homework: Codable {
    let id : Int
    let text : String
}
enum Grade: String {
    case two = "2"
    case three = "3"
    case four = "4"
    case five = "5"
    case noGrade = "-"
    case absent = "H"
    
    var color: UIColor {
        switch self {
        case .two: return UIColor.neobisGradeTwo
        case .three: return UIColor.neobisGradeThree
        case .four: return UIColor.neobisGradeFour
        case .five: return UIColor.neobisGradeFive
        case .noGrade: return UIColor.neobisGradeN
        case .absent: return UIColor.neobisGradeN
        }
    }
}

// MARK: Student's lesson details
struct StudentLessonDetail: Codable {
    let id : Int
    let subject : Subject
    let homework : StudentHomework?
    let submission : StudentSubmission?
}
struct Subject: Codable {
    let id : Int
    let name : String
    let teacher : FullNameUser
}
struct StudentHomework: Codable {
    let id : Int
    let topic : String
    let text : String
    let deadline : Date
    let files : [File]
    let hasMark : Bool
    let canCancel : Bool
}
struct File: Codable {
    let id : Int
    let file : String
}
struct FullNameUser: Codable {
    let id : Int
    let fullName : String
    let firstName : String
    let lastName : String
    let patronymic : String
}
struct StudentSubmission: Codable {
    let id : Int
    let student : FullNameUser
    let homework: Int
    let files : [File]
    let submittedDate : String
    let studentComment : String
    let teacherComment : String?
    let isRevision : Bool
    let mark : String?
}

struct StudentDay: Codable {
    let id: Int
    let name: String
    let lessonsCount: Int
}


// MARK: Mock data
let dayLessonsMockData : [StudentLesson] = [
    .init(id: 137, day: Day(id: 1, name: "Пн"), room: Room(id: 1, name: "111"), subject: SubjectName(id: 1, name: "Биология"), homework: nil, startTime: "08:00", endTime: "08:45", mark: "5"),
    .init(id: 138, day: Day(id: 1, name: "Пн"), room: Room(id: 2, name: "112"), subject: SubjectName(id: 2, name: "Математика"), homework: nil, startTime: "08:50", endTime: "09:35", mark: "4"),
    .init(id: 139, day: Day(id: 1, name: "Пн"), room: Room(id: 3, name: "113"), subject: SubjectName(id: 3, name: "Физика"), homework: nil, startTime: "09:40", endTime: "10:25", mark: "3"),
    .init(id: 140, day: Day(id: 1, name: "Пн"), room: Room(id: 4, name: "114"), subject: SubjectName(id: 4, name: "Химия"), homework: nil, startTime: "10:30", endTime: "11:15", mark: "2"),
    .init(id: 141, day: Day(id: 1, name: "Пн"), room: Room(id: 5, name: "115"), subject: SubjectName(id: 5, name: "Геометрия"), homework: nil, startTime: "11:20", endTime: "12:05", mark: "H"),
    .init(id: 142, day: Day(id: 1, name: "Пн"), room: Room(id: 6, name: "211"), subject: SubjectName(id: 6, name: "География"), homework: nil, startTime: "12:10", endTime: "12:55", mark: nil)
]
let studentWeekMock: [StudentDay] = [
    .init(id: 0, name: "ПН", lessonsCount: 1),
    .init(id: 1, name: "ВТ", lessonsCount: 2),
    .init(id: 2, name: "СР", lessonsCount: 3),
    .init(id: 3, name: "ЧТ", lessonsCount: 4),
    .init(id: 4, name: "ПТ", lessonsCount: 5),
    .init(id: 5, name: "СБ", lessonsCount: 22),
]
var subjectDetails : StudentLessonDetail = .init(id: 1, subject: Subject(id: 1, name: "Biology", teacher: FullNameUser(id: 1, fullName: "Valerie V. Vacek", firstName: "Valerie", lastName: "Vacek", patronymic: "V.V.Vacek")), homework: StudentHomework(id: 1, topic: "Введение", text: "Ну введем что-нибудь", deadline: .now, files: [File(id: 1, file: "")], hasMark: false, canCancel: false), submission: nil)
