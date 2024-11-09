import Foundation
import UIKit

// MARK: Student's lesson in the list of subjects
struct SchoolLesson: Codable {
    let id : Int
    let day : Day
    let room : Room
    let subject : SubjectName
    let homework : Homework?
    let startTime : String
    let endTime : String
    let mark : String?
    let homeworkCount: Int?
    let grade: GradeName?
}
struct GradeName: Codable {
    let id: Int
    let name: String
    let subjects: [SubjectName]?
}
struct Day: Codable {
    let id : Int
    let name : String
}
struct Room: Codable {
    let id : Int
    let name : String
}
struct SubjectName: Codable, Equatable {
    let id : Int
    let name : String
}
struct Homework: Codable {
    let id: Int
    let text: String
    let topic: String
}
enum Grade: String, CaseIterable, Codable {
    case absent = "Н"
    case two = "2"
    case three = "3"
    case four = "4"
    case five = "5"
    case noGrade = "-"
    
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
    var word: String {
        switch self {
        case .two: return "(неуд)"
        case .three: return "(удв)"
        case .four: return "(хор)"
        case .five: return "(отл)"
        case .noGrade: return ""
        case .absent: return ""
        }
    }
    var backgroundColor: UIColor {
        switch self {
        case .two: return UIColor.neobisGradeTwoBackground
        case .three: return UIColor.neobisGradeThreeBackground
        case .four: return UIColor.neobisGradeFourBackground
        case .five: return UIColor.neobisGradeFiveBackground
        case .noGrade: return UIColor.neobisExtralightGray
        case .absent: return UIColor.neobisExtralightGray
        }
    }
}

// MARK: Student's lesson details
struct StudentLessonDetail: Codable {
    let id : Int
    let subject : StudentSubject
    let homework : StudentHomework?
    let submission : StudentSubmission?
}
struct StudentSubject: Codable {
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
    let patronymic : String?
    let mark: String?
    let avgMark: String?
    let quarterMarks: [QuaterMark]?
}
struct StudentSubmission: Codable {
    let id : Int
    let student : FullNameUser
    let homework: Int
    let files : [File]
    let submittedDate : String
    let studentComment : String?
    let teacherComment : String?
    let isRevision : Bool
    let mark : String?
}

struct SchoolDay: Codable {
    let id: Int
    let name: String
    let lessonsCount: Int
}
struct QuaterMark: Codable {
    let id: Int
    let student: Int
    let subject: Int
    let quarter: Quater
    let finalMark: Grade?
}
enum Quater: String, CaseIterable, Codable {
    case first, second, third, fourth, final

    var romanNumberSign: String {
        switch self {
        case .first: return "I четверть"
        case .second: return "II четверть"
        case .third: return "III четверть"
        case .fourth: return "IV четверть"
        case .final: return "Годовая"
        }
    }

    var romanNum: String {
        switch self {
        case .first: return "I"
        case .second: return "II"
        case .third: return "III"
        case .fourth: return "IV"
        case .final: return "ИТОГ"
        }
    }

    var subtitle: String {
        switch self {
        case .first, .second, .third, .fourth: return "четверть"
        case .final: return "за уч. год"
        }
    }
}
struct DTOLastMarks: Codable {
    let totalCount: Int
    let totalPages: Int
    let list: [LastMarks?]
}
struct LastMarks: Codable {
    let id: Int
    let name: String
    let marks: [Mark]?
    let quarterMark: QuaterMark?
}
struct Mark: Codable {
    let id: Int
    let student: Int
    let subject: Int
    let submission: Int?
    let quarter: Quater
    let mark: Grade
}
struct DTOSubjectClassworkLastMarks: Codable {
    let totalCount: Int
    let totalPages: Int
    let list: [StudentSubjectMark]
}
struct StudentSubjectMark: Codable {
    let id: Int
    let student: Int
    let subject: StudentSubject
    let quarter: Quater
    let mark: Grade
    let createdAt: String
}
struct DTOSubjectHomeworkLastMarks: Codable {
    let totalCount: Int
    let totalPages: Int
    let list: [TeacherSubmission]
}
