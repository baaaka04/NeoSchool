import Foundation
import UIKit

class TeacherDetailsViewModel: StudentHomeworkProtocol, CommentRepresentableProtocol {
    weak var teacherAPI: DayScheduleAPI?
    weak var view: SubjectDetailsViewModelActionable?

    private let lessonId: Int
    var lessonDetails: TeacherLessonDetail?
    var submissionDetails: TeacherSubmissionDetails?
    var students: [TeacherClassItem] = []
    var submissions: [TeacherClassItem] = []

    var attachedFiles: [AttachedFile] = []
    var attachedFilesURLs: [String]?
    var submissionFilesUrls: [String]?

    var userComment: String?
    var grade: Grade?

    init(lessonId: Int, teacherAPI: DayScheduleAPI?) {
        self.lessonId = lessonId
        self.teacherAPI = teacherAPI
    }

    // MARK: - API functions
    func getLessonDetails() async throws {
        self.lessonDetails = try await teacherAPI?.getTeacherLessonDetail(forLessonId: self.lessonId)
    }

    func getStudentList(currentPage: Int) async throws -> Int {
        guard let lessonDetails,
              let students = try await teacherAPI?.getStudentList(subjectId: lessonDetails.subject.id, gradeId: lessonDetails.grade.id, page: currentPage) else {
            throw MyError.noDataReceived }
        let newStudents = students.list.map { TeacherClassItem(studentSubmission: $0) }
        self.students.append(contentsOf: newStudents)
        return students.totalPages
    }

    func getStudentLessons(studentId: Int, currentPage: Int) async throws -> Int {
        guard let submissionsDTO = try await teacherAPI?.getStudentLessons(studentId: studentId, page: currentPage)
        else { throw MyError.noDataReceived }
        var submissions = submissionsDTO.list

        for ind in 0..<submissions.count {
            guard let date = try? DateConverter.convertDateStringToDay(from: submissions[ind].submittedDate, dateFormat: .long),
                  let time = try? DateConverter.convertDateStringToHoursAndMinutes(
                    from: submissions[ind].submittedDate,
                    dateFormat: .long
                  )
            else { throw MyError.noDataReceived }
            submissions[ind].submittedDate = date + " в " + time
        }
        let newSubmissions = submissions.map { TeacherClassItem(studentLesson: $0) }
        self.submissions.append(contentsOf: newSubmissions)
        return submissionsDTO.totalPages
    }

    func setHomework(topic: String, text: String, deadline: String, completion: @escaping (_ done: Bool) -> Void) async throws {
        do {
            self.lessonDetails = try await teacherAPI?.setHomework(
                lessonId: self.lessonId,
                files: self.attachedFiles,
                topic: topic,
                text: text,
                deadline: deadline
            )
            completion(true)
        } catch {
            completion(false)
            throw error
        }
    }

    func getTeacherHomeworkFiles() async throws {
        guard let homeworkId = lessonDetails?.homework?.id else { throw MyError.badNetwork }
        self.attachedFilesURLs = try await teacherAPI?.getTeacherHomeworkFiles(homeworkId: homeworkId)
    }

    func getSubmissionDetails(submissionId: Int) async throws {
        self.submissionFilesUrls = nil
        self.submissionDetails = nil
        guard var submission = try await teacherAPI?.getSubmissionDetails(submissionId: submissionId)
        else { throw MyError.badNetwork }
        let day = try convertDateStringToDay(from: submission.submittedDate, dateFormat: .long)
        let time = try convertDateStringToHoursAndMinutes(from: submission.submittedDate, dateFormat: .long)
        submission.submittedDate = day + " в " + time
        let deadlineDate = try convertDateStringToDay(from: submission.homework.deadline, dateFormat: .short)
        submission.homework.deadline = "Срок сдачи: \(deadlineDate)"
        self.submissionDetails = submission
        self.submissionFilesUrls = submission.files.map(\.file)
    }

    func reviseSubmission(submissionId: Int) async throws {
        try await teacherAPI?.reviseSubmission(submissionId: submissionId)
    }

    func submit(_ submissionId: Int?) async throws {
        guard let submissionId,
              let grade,
              let dateString = lessonDetails?.homework?.deadline
        else { throw MyError.noDataReceived }
        guard let submission = try await teacherAPI?.gradeSubmission(
            submissionId: submissionId,
            grade: grade.rawValue,
            teacherComment: userComment,
            date: dateString
        ) else { throw MyError.badNetwork }
        self.submissionDetails = submission
        self.submissionFilesUrls = submission.files.map(\.file)
    }

    // MARK: - Public functions
    func add(image: UIImage) {
        self.attachedFiles.append(AttachedFile(image: image))

        view?.updateCollectionView()
    }

    func remove(file: AttachedFile) {
        guard let ind = self.attachedFiles.firstIndex(where: { $0.id == file.id }) else { return }
        self.attachedFiles.remove(at: ind)

        view?.updateCollectionView()
    }

    func convertDateStringToHoursAndMinutes(from dateString: String, dateFormat: DateFormat) throws -> String {
        let date = try getDateFromString(dateString: dateString, dateFormat: dateFormat)
        return getTimeFromDate(date: date)
    }

    func convertDateStringToDay(from dateString: String, dateFormat: DateFormat) throws -> String {
        let date = try getDateFromString(dateString: dateString, dateFormat: dateFormat)
        return getDayFromDate(date: date)
    }

    private func getDateFromString(dateString: String, dateFormat: DateFormat) throws -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat.rawValue
        guard let date = dateFormatter.date(from: dateString) else { throw MyError.invalidDateFormat }
        return date
    }

    private func getTimeFromDate(date: Date) -> String {
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "HH:mm"
        return timeFormatter.string(from: date)
    }

    private func getDayFromDate(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        return dateFormatter.string(from: date)
    }
}
