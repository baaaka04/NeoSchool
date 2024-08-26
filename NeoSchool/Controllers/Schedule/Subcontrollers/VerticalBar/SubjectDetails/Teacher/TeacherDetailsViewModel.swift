import Foundation


class TeacherDetailsViewModel {

    weak var teacherAPI: DayScheduleAPI?

    private let lessonId: Int
    var lessonDetails: TeacherLessonDetail?
    var students: [TeacherClassItem]?
    var submissions: [TeacherClassItem]?

    init(lessonId: Int, teacherAPI: DayScheduleAPI?) {
        self.lessonId = lessonId
        self.teacherAPI = teacherAPI
    }

    //MARK: - API functions
    func getLessonDetails() async throws {
        self.lessonDetails = try await teacherAPI?.getTeacherLessonDetail(forLessonId: self.lessonId)
    }

    func getStudentList() async throws {
        guard let lessonDetails else { return }
        self.students = try await teacherAPI?.getStudentList(subjectId: lessonDetails.subject.id, gradeId: lessonDetails.grade.id, page: 1)
    }

    func getStudentLessons(studentId: Int) async throws {
        guard let lessonDetails else { return }
        self.submissions = try await teacherAPI?.getStudentLessons(studentId: studentId, gradeId: lessonDetails.grade.id, page: 1)
    }

    //MARK: - Service functions
    func convertDateStringToHoursAndMinutes(from dateString: String) throws -> String {
        let date = try getDateFromString(dateString: dateString)
        let timeString = getTimeFromDate(date: date)
        return timeString
    }

    func convertDateStringToDay(from dateString: String) throws -> String {
        let date = try getDateFromString(dateString: dateString)
        let dayString = getDayFromDate(date: date)
        return dayString
    }

    private func getDateFromString(dateString: String) throws -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssXXX"
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
