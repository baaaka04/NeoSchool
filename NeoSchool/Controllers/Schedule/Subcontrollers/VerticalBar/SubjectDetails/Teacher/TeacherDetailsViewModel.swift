import Foundation
import UIKit

class TeacherDetailsViewModel {

    weak var teacherAPI: DayScheduleAPI?
    weak var view: SubjectDetailsViewModelActionable?

    private let lessonId: Int
    var lessonDetails: TeacherLessonDetail?
    var students: [TeacherClassItem] = []
    var submissions: [TeacherClassItem] = []

    var attachedFiles : [AttachedFile] = []
    var attachedFilesURLs: [String]?

    init(lessonId: Int, teacherAPI: DayScheduleAPI?) {
        self.lessonId = lessonId
        self.teacherAPI = teacherAPI
    }

    //MARK: - API functions
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
        guard var submissionsDTO = try await teacherAPI?.getStudentLessons(studentId: studentId, page: currentPage) else { throw MyError.noDataReceived }
        var submissions = submissionsDTO.list

        for i in 0..<submissions.count {
            guard let date = try? convertDateStringToDay(from: submissions[i].submittedDate, dateFormat: .long),
                  let time = try? convertDateStringToHoursAndMinutes(from: submissions[i].submittedDate, dateFormat: .long) else { throw MyError.noDataReceived }
            submissions[i].submittedDate = date + " в " + time
        }
        let newSubmissions = submissions.map { TeacherClassItem(studentLesson: $0) }
        self.submissions.append(contentsOf: newSubmissions)
        return submissionsDTO.totalPages
    }

    func setHomework(topic: String, text: String, deadline: String, completion: @escaping(_ done: Bool) -> Void) async throws {
        do {
            self.lessonDetails = try await teacherAPI?.setHomework(lessonId: self.lessonId, files: self.attachedFiles, topic: topic, text: text, deadline: deadline)
            completion(true)
        } catch {
            completion(false)
            throw error
        }
    }

    func getTeacherHomeworkFiles() async throws -> Void {
        guard let homeworkId = lessonDetails?.homework?.id else { throw MyError.badNetwork }
        self.attachedFilesURLs = try await teacherAPI?.getTeacherHomeworkFiles(homeworkId: homeworkId)
    }

    //MARK: - Public functions
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
        let timeString = getTimeFromDate(date: date)
        return timeString
    }

    func convertDateStringToDay(from dateString: String, dateFormat: DateFormat) throws -> String {
        let date = try getDateFromString(dateString: dateString, dateFormat: dateFormat)
        let dayString = getDayFromDate(date: date)
        return dayString
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
        let timeString = timeFormatter.string(from: date)

        return timeString
    }

    private func getDayFromDate(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        let dateString = dateFormatter.string(from: date)
        return dateString
    }

}
