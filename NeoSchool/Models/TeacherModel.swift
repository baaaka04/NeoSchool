import Foundation

struct TeacherLessonDetail: Codable {
    let id: Int
    let subject: StudentSubject
    let homework: TeacherHomework
    let submissions: [TeacherSubmission]?
    let grade: GradeName
    let room: Room
    let startTime: String
    let endTime: String
    let studentCount: Int
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
struct StudentSubmissionCount: Codable {
      let id: Int
      let fullName: String
      let firstName: String
      let lastName: String
      let patronymic: String
      let submissionsCount: String
}
