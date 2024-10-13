import UIKit

class SubjectDetailsViewModel: SubjectDetailsViewModelRepresentable, CommentRepresentableProtocol {
    
    weak var view: SubjectDetailsViewModelActionable?
    weak var lessonAPI: DayScheduleAPI?
    
    private var lessonDetails: StudentLessonDetail?
    private let lessonId: Int
    
    var attachedFiles : [AttachedFile] = []
    var userComment : String?
    var grade: Grade?

    var subjectName: String {
        lessonDetails?.subject.name ?? ""
    }
    var teacherName: NSAttributedString {
        let head = "Учитель: "
        let tail = lessonDetails?.subject.teacher.fullName ?? ""
        let markString = head + tail
        let attributedString = NSMutableAttributedString(string: markString)
        attributedString.addAttribute(.font, value: AppFont.font(type: .Medium, size: 16), range: NSRange(location: head.count, length: tail.count))
        return  attributedString
    }
    var homeworkTopic: NSAttributedString {
        let head = "Тема урока: "
        let tail = lessonDetails?.homework?.topic ?? ""
        let markString = head + tail
        let attributedString = NSMutableAttributedString(string: markString)
        attributedString.addAttribute(.font, value: AppFont.font(type: .Medium, size: 16), range: NSRange(location: head.count, length: tail.count))
        return  attributedString
    }
    var homeworkDeadline: String {
        let deadlineString = "Срок сдачи: "
        guard let deadline = lessonDetails?.homework?.deadline else {return deadlineString + " не назначено"}
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        return deadlineString + formatter.string(from: deadline)
    }
    var homeworkMark: Grade? {
        guard let markString = lessonDetails?.submission?.mark else { return nil }
        return Grade(rawValue: markString )
    }
    var homeworkText: String? {
        lessonDetails?.homework?.text
    }
    
    var homeworkFileURLs: [String]? {
        return self.lessonDetails?.homework?.files.compactMap { $0.file }
    }
    
    var isCancelable: Bool? {
        lessonDetails?.homework?.canCancel
    }
    
    init(lessonId: Int, lessonAPI: DayScheduleAPI?) {
        self.lessonId = lessonId
        self.lessonAPI = lessonAPI
    }
    
    func getLessonDetailData() async throws {
        do {
            lessonDetails = try await lessonAPI?.getStudentLessonDetail(forLessonId: lessonId)
        } catch {
            print(error)
        }
    }
    
    func add(image: UIImage) {
        self.attachedFiles.append(AttachedFile(image: image))
        
        view?.updateCollectionView()
    }
    
    func remove(file: AttachedFile) {
        guard let ind = self.attachedFiles.firstIndex(where: { $0.id == file.id }) else { return }
        self.attachedFiles.remove(at: ind)
        
        view?.updateCollectionView()
    }
    
    func submit(_ submissionId: Int? = nil) async throws {
        guard attachedFiles.count > 0,
            let homeworkId : Int = lessonDetails?.homework?.id else { throw URLError(.fileDoesNotExist) }
        try await lessonAPI?.uploadFiles(homeworkId: homeworkId, files: attachedFiles, studentComment: userComment)
        self.attachedFiles = []
    }
    
    func cancelSubmission() async throws {
        guard let submissionId else { throw MyError.nothingToCancel }
        try await lessonAPI?.cancelSubmission(submissionId: submissionId)
    }

}

protocol SubjectDetailsViewModelRepresentable: AnyObject {
    var subjectName: String { get }
    var teacherName: NSAttributedString{ get }
    var homeworkTopic: NSAttributedString { get }
    var homeworkDeadline: String { get }
    var homeworkMark: Grade? { get }
    var homeworkText: String? { get }
    var attachedFiles: [AttachedFile] { get }
    var homeworkFileURLs: [String]? { get }
    var userComment: String? { get set }

    var view: SubjectDetailsViewModelActionable? { get set }
    
    func getLessonDetailData() async throws
    
    func add(image: UIImage)
    func remove(file: AttachedFile)
    func submit(_ submissionId: Int?) async throws
    
    var files: [String]? { get }
    var studentCommentSubmitted: String? { get }
    var teacherComment: String? { get }
    var mark: String? { get }
    var isSubmitted: Bool { get }
    var isCancelable: Bool? { get }
    func cancelSubmission() async throws
}

protocol SubjectDetailsViewModelActionable: AnyObject {
    func updateCollectionView()
}

protocol HomeworkSubmissionRepresentable: AnyObject {
    var files: [String]? { get }
    var studentCommentSubmitted: String? { get }
    var teacherComment: String? { get }
    var mark: String? { get }
    var isSubmitted: Bool { get }
}

extension SubjectDetailsViewModel: HomeworkSubmissionRepresentable {
    var submissionId: Int? {
        lessonDetails?.submission?.id
    }
    
    var isSubmitted: Bool {
        lessonDetails?.submission != nil
    }
    
    var files: [String]? {
        lessonDetails?.submission?.files.compactMap { $0.file }
    }
    
    var studentCommentSubmitted: String? {
        lessonDetails?.submission?.studentComment
    }
    
    var teacherComment: String? {
        lessonDetails?.submission?.teacherComment
    }
    
    var mark: String? {
        lessonDetails?.submission?.mark
    }

}
