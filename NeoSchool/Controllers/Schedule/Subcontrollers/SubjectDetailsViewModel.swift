import Foundation

class SubjectDetailsViewModel: SubjectDetailsViewModelRepresentable {
    
    var subjectName: String {
        lessonDetails?.subject.name ?? ""
    }
    var teacherName: String {
        "Учитель: \(lessonDetails?.subject.teacher.fullName ?? "")"
    }
    var homeworkTopic: String {
        "Тема урока: \(lessonDetails?.homework?.topic ?? "")"
    }
    var homeworkDeadline: String {
        let deadlineString = "Срок сдачи: "
        guard let deadline = lessonDetails?.homework?.deadline else {return deadlineString}
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        return deadlineString + formatter.string(from: deadline)
    }
    var homeworkMark: String {
        let markString = "Оценка за задание: "
        return markString + (lessonDetails?.submission?.mark ?? "не получена")
    }
    var homeworkText: String? {
        lessonDetails?.homework?.text
    }
    
    let lessonId: Int
    let lessonAPI: DayScheduleAPI
    
    private var lessonDetails: StudentLessonDetail?
    
    init(lessonId: Int, lessonAPI: DayScheduleAPI) {
        self.lessonId = lessonId
        self.lessonAPI = lessonAPI
    }
    
    func getLessonDetailData() async throws {
        do {
            lessonDetails = try await lessonAPI.getLessonDetail(forLessonId: lessonId)
        } catch {
            print(error)
        }
    }

}

protocol SubjectDetailsViewModelRepresentable: AnyObject {
    var subjectName: String { get }
    var teacherName: String { get }
    var homeworkTopic: String { get }
    var homeworkDeadline: String { get }
    var homeworkMark: String { get }
    var homeworkText: String? { get }
    
    func getLessonDetailData() async throws
}

