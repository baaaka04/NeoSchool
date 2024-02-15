import Foundation
import UIKit

// MARK: Student's lesson in the list of subjects
struct StrudentLesson {
    let id : Int
    let day : Day
    let room : Room
    let subject : SubjectName
    let homework : Homework?
    let startTime : String
    let endTime : String
}
struct Day {
    let id : Int
    let name : String
}
struct Room {
    let id : Int
    let name : String
}
struct SubjectName {
    let id : Int
    let name : String
}
struct Homework {
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
struct StudentLessonDetail {
    let id : Int
    let subject : Subject
    let homework : StudentHomework?
    let submission : StudentSubmission?
}
struct Subject {
    let id : Int
    let name : String
    let teacher : FullNameUser
}
struct StudentHomework {
    let id : Int
    let topic : String
    let text : String
    let deadline : String
    let files : [File]
    let hasMark : String
    let canCancel : String
}
struct File {
    let id : Int
    let file : String
}
struct FullNameUser {
    let id : Int
    let fullName : String
    let firstName : String
    let lastName : String
    let patronymic : String
}
struct StudentSubmission {
    let id : Int
    let student : FullNameUser
    let homework: Int
    let files : [File]
    let submittedDate : String
    let studentComment : String
    let teacherComment : String
    let isRevision : Bool
    let mark : String
}




// MARK: Mock data
let dayLessonsMockData : [StrudentLesson] = [
    .init(id: 137, day: Day(id: 1, name: "Пн"), room: Room(id: 1, name: "111"), subject: SubjectName(id: 1, name: "Биология"), homework: nil, startTime: "08:00", endTime: "08:45"),
    .init(id: 138, day: Day(id: 1, name: "Пн"), room: Room(id: 2, name: "112"), subject: SubjectName(id: 2, name: "Математика"), homework: nil, startTime: "08:50", endTime: "09:35"),
    .init(id: 139, day: Day(id: 1, name: "Пн"), room: Room(id: 3, name: "113"), subject: SubjectName(id: 3, name: "Физика"), homework: nil, startTime: "09:40", endTime: "10:25"),
    .init(id: 140, day: Day(id: 1, name: "Пн"), room: Room(id: 4, name: "114"), subject: SubjectName(id: 4, name: "Химия"), homework: nil, startTime: "10:30", endTime: "11:15"),
    .init(id: 141, day: Day(id: 1, name: "Пн"), room: Room(id: 5, name: "115"), subject: SubjectName(id: 5, name: "Геометрия"), homework: nil, startTime: "11:20", endTime: "12:05"),
    .init(id: 142, day: Day(id: 1, name: "Пн"), room: Room(id: 6, name: "211"), subject: SubjectName(id: 6, name: "География"), homework: nil, startTime: "12:10", endTime: "12:55")
]
let studentWeek: [StudentDay] = [
    .init(id: 0, name: "ПН", lessonsCount: 1),
    .init(id: 1, name: "ВТ", lessonsCount: 2),
    .init(id: 2, name: "СР", lessonsCount: 3),
    .init(id: 3, name: "ЧТ", lessonsCount: 4),
    .init(id: 4, name: "ПТ", lessonsCount: 5),
    .init(id: 5, name: "СБ", lessonsCount: 22),
]
