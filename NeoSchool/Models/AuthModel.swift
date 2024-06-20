import Foundation

enum UserRole {
    case teacher, student
}

struct ResetPasswordResponse: Codable {
    let message: String
    let userId: Int
}

struct VerifyPasswordResponse: Codable {
    let message: String
    let refresh: String
    let access: String
}

struct UserProfile: Codable {
    let id: Int
    let username: String
    let email: String
    let firstName: String
    let lastName: String
    let patronymic: String
    let fullName: String
    let isTeacher: Bool
    let schoolName: String
    
    let classTeacherGrade: SchoolGrade?
    let teacherGrades: [SchoolGrade]?
    let studentGrade: SchoolGrade?
    let studentClassTeacher: StudentClassTeacher?
}

struct SchoolGrade: Codable {
    let id: Int
    let name: String
}

struct StudentClassTeacher: Codable {
    let id: Int
    let fullName: String
    let firstName: String
    let lastName: String
    let patronymic: String
}

struct ProfileInfo {
    
    init(userProfile: UserProfile) {
        self.userFullName = userProfile.fullName
        self.userEmail = userProfile.email
        self.userSchoolName = userProfile.schoolName
        self.userFirstName = userProfile.firstName
        
        if userProfile.isTeacher {
            self.role = .teacher
            self.userMainClass = userProfile.classTeacherGrade?.name ?? ""
            let teacherGrades = userProfile.teacherGrades?.reduce("", { result, grade in
                result.isEmpty ? grade.name : result + ", " + grade.name
            })
            self.userOtherInfo = teacherGrades ?? ""
        } else {
            self.role = .student
            self.userMainClass = userProfile.studentGrade?.name ?? ""
            self.userOtherInfo = userProfile.studentClassTeacher?.fullName ?? ""
        }
    }
    
    let role: UserRole
    let userFirstName: String
    let userFullName: String
    let userEmail: String
    let userSchoolName: String
    let userMainClass: String
    let userOtherInfo: String
}
