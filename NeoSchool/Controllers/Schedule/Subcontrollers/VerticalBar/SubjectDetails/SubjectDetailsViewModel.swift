import Foundation
import UIKit

class SubjectDetailsViewModel: SubjectDetailsViewModelRepresentable {
    
    weak var view: SubjectDetailsViewModelActionable?
    weak var lessonAPI: DayScheduleAPI?
    
    var attachedFiles : [AttachedFile] = []
    var studentComment : String? = "test ios comment"
    
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
    
    private var lessonDetails: StudentLessonDetail?
    
    init(lessonId: Int, lessonAPI: DayScheduleAPI?) {
        self.lessonId = lessonId
        self.lessonAPI = lessonAPI
    }
    
    func getLessonDetailData() async throws {
        do {
            lessonDetails = try await lessonAPI?.getLessonDetail(forLessonId: lessonId)
        } catch {
            print(error)
        }
    }
    
    func add(image: UIImage) {
        var newFile = AttachedFile(name: "", image: image)
        newFile.name = "image_\(newFile.id.suffix(5).lowercased()).jpg"
        self.attachedFiles.append(newFile)
        
        view?.reloadCollectionView()
    }
    
    func remove(file: AttachedFile) {
        guard let ind = self.attachedFiles.firstIndex(where: { $0.id == file.id }) else { return }
        self.attachedFiles.remove(at: ind)
        
        view?.reloadCollectionView()
    }
    
    func sendFiles() async throws {
        guard attachedFiles.count > 0,
            let homeworkId : Int = lessonDetails?.homework?.id else { throw URLError(.fileDoesNotExist) }
        try await lessonAPI?.uploadFiles(homeworkId: homeworkId, files: attachedFiles, studentComment: studentComment)
    }


}

protocol SubjectDetailsViewModelRepresentable: AnyObject {
    var subjectName: String { get }
    var teacherName: NSAttributedString{ get }
    var homeworkTopic: NSAttributedString { get }
    var homeworkDeadline: String { get }
    var homeworkMark: NSAttributedString { get }
    var homeworkText: String? { get }
    var attachedFiles: [AttachedFile] { get }
    
    var view: SubjectDetailsViewModelActionable? { get set }
    
    func getLessonDetailData() async throws
    
    func add(image: UIImage)
    func remove(file: AttachedFile)
    func sendFiles() async throws
}

protocol SubjectDetailsViewModelActionable: AnyObject {
    func reloadCollectionView()
}

