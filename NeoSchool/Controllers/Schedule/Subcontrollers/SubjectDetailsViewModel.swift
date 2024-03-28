import Foundation
import UIKit

class SubjectDetailsViewModel: SubjectDetailsViewModelRepresentable {
    
    var subjectName: String {
        lessonDetails?.subject.name ?? ""
    }
    var teacherName: NSAttributedString {
        let head = "Учитель: "
        let tail = lessonDetails?.subject.teacher.fullName ?? ""
        let markString = head + tail
        let attributedString = NSMutableAttributedString(string: markString)
        attributedString.addAttribute(.font, value: UIFont(name: "Jost-Medium", size: 16), range: NSRange(location: head.count, length: tail.count))
        return  attributedString
    }
    var homeworkTopic: NSAttributedString {
        let head = "Тема урока: "
        let tail = lessonDetails?.homework?.topic ?? ""
        let markString = head + tail
        let attributedString = NSMutableAttributedString(string: markString)
        attributedString.addAttribute(.font, value: UIFont(name: "Jost-Medium", size: 16), range: NSRange(location: head.count, length: tail.count))
        return  attributedString
    }
    var homeworkDeadline: String {
        let deadlineString = "Срок сдачи: "
        guard let deadline = lessonDetails?.homework?.deadline else {return deadlineString + " не назначено"}
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        return deadlineString + formatter.string(from: deadline)
    }
    var homeworkMark: NSAttributedString {
        let head = "Оценка за задание: "
        let tail = lessonDetails?.submission?.mark ?? "не получена"
        let markString = head + tail
        let attributedString = NSMutableAttributedString(string: markString)
        attributedString.addAttribute(.font, value: UIFont(name: "Jost-Medium", size: 20), range: NSRange(location: head.count, length: tail.count))
        return  attributedString
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
    var teacherName: NSAttributedString{ get }
    var homeworkTopic: NSAttributedString { get }
    var homeworkDeadline: String { get }
    var homeworkMark: NSAttributedString { get }
    var homeworkText: String? { get }
    
    func getLessonDetailData() async throws
}

