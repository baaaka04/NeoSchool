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
    let studentComment : String?
    let teacherComment : String?
    let isRevision : Bool
    let mark : String?
}

struct StudentDay: Codable {
    let id: Int
    let name: String
    let lessonsCount: Int
}

