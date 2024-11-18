import Foundation

class MockNotificationsAPI: NotificationsNetworkAPIProtocol {
    func getNotifications(page _: Int, limit _: Int) async throws -> DTONotifications {
        throw MyError.badNetwork
    }

    func checkAsRead(notificationId _: Int) async throws {
        throw MyError.badNetwork
    }
}

class MockTeacherDayScheduleAPI: TeacherLessonDayProtocol {
    func getLessons(forDayId _: Int, userRole _: UserRole) async throws -> [SchoolLesson] {
        [
            .init(
                id: 1,
                day: Day(id: 1, name: "Пн"),
                room: Room(id: 1, name: "302"),
                subject: SubjectName(id: 1, name: "Биология"),
                homework: nil,
                startTime: "2012-01-26T13:51:50.417-07:00",
                endTime: "2012-01-26T13:51:50.417-07:00",
                mark: nil,
                homeworkCount: nil,
                grade: nil),
            .init(
                id: 1,
                day: Day(id: 1, name: "Пн"),
                room: Room(id: 1, name: "302"),
                subject: SubjectName(id: 1, name: "Физика"),
                homework: nil,
                startTime: "2012-01-26T13:51:50.417-07:00",
                endTime: "2012-01-26T13:51:50.417-07:00",
                mark: nil,
                homeworkCount: nil,
                grade: nil),
            .init(
                id: 1,
                day: Day(id: 1, name: "Пн"),
                room: Room(id: 1, name: "302"),
                subject: SubjectName(id: 1, name: "Химия"),
                homework: nil,
                startTime: "2012-01-26T13:51:50.417-07:00",
                endTime: "2012-01-26T13:51:50.417-07:00",
                mark: nil,
                homeworkCount: nil,
                grade: nil),
            .init(
                id: 1,
                day: Day(id: 1, name: "Пн"),
                room: Room(id: 1, name: "302"),
                subject: SubjectName(id: 1, name: "Математика"),
                homework: nil,
                startTime: "2012-01-26T13:51:50.417-07:00",
                endTime: "2012-01-26T13:51:50.417-07:00",
                mark: nil,
                homeworkCount: nil,
                grade: nil),
        ]
    }

    func getTeacherLessonDetail(forLessonId _: Int) async throws -> TeacherLessonDetail {
        TeacherLessonDetail(
            id: 1,
            subject: StudentSubject(
                id: 1,
                name: "Биология",
                teacher: FullNameUser(
                    id: 1,
                    fullName: "Петрова Ольга Викторовна",
                    firstName: "Ольга",
                    lastName: "Петрова",
                    patronymic: "Петрова О.В.",
                    mark: nil,
                    avgMark: nil,
                    quarterMarks: nil)),
            homework: TeacherHomework(
                id: 1,
                text: "Прочитать главу 3",
                deadline: "2012-01-26T08:40:00.000+06:00",
                filesCount: 1),
            submissions: nil,
            grade: GradeName(
                id: 1,
                name: "5 A",
                subjects: nil),
            room: Room(id: 1, name: "301"),
            startTime: "2012-01-26T08:00:00.000+06:00",
            endTime: "2012-01-26T08:40:00.000+06:00",
            studentsCount: 15
        )
    }

    func getStudentList(subjectId _: Int, gradeId _: Int, page _: Int) async throws -> DTOStudentSubmissionCount {
        let data: [StudentSubmissionCount] = [
            .init(id: 1, fullName: "Березин Артем Игоервич", firstName: "Артем", lastName: "Березин",
                  patronymic: "Березин А.И.", submissionsCount: 0),
            .init(id: 2, fullName: "Ревзин Иван Александрович", firstName: "Иван", lastName: "Ревзин",
                  patronymic: "Ревизн И.А.", submissionsCount: 6),
            .init(id: 3, fullName: "Щетинин Денис Александрович", firstName: "Денис", lastName: "Щетинин",
                  patronymic: "Щетинин Д.А.", submissionsCount: 3),
            .init(id: 4, fullName: "Иванов Иван Иванович", firstName: "Иван", lastName: "Иванов",
                  patronymic: "Иванов И.И.", submissionsCount: 4),
            .init(id: 5, fullName: "Иванов Иван Иванович", firstName: "Иван", lastName: "Иванов",
                  patronymic: "Иванов И.И.", submissionsCount: 4),
            .init(id: 6, fullName: "Иванов Иван Иванович", firstName: "Иван", lastName: "Иванов",
                  patronymic: "Иванов И.И.", submissionsCount: 4),
            .init(id: 7, fullName: "Иванов Иван Иванович", firstName: "Иван", lastName: "Иванов",
                  patronymic: "Иванов И.И.", submissionsCount: 4),
            .init(id: 8, fullName: "Иванов Иван Иванович", firstName: "Иван", lastName: "Иванов",
                  patronymic: "Иван И.И.", submissionsCount: 4),
            .init(id: 9, fullName: "Иванов Иван Иванович", firstName: "Иван", lastName: "Иванов",
                  patronymic: "Иванов И.И.", submissionsCount: 4),
            .init(id: 10, fullName: "Иванов Иван Иванович", firstName: "Иван", lastName: "Иванов",
                  patronymic: "Иванов И.И.", submissionsCount: 4),
            .init(id: 11, fullName: "Иванов Иван Иванович", firstName: "Иван", lastName: "Иванов",
                  patronymic: "Иванов И.И.", submissionsCount: 4),
        ]
        return DTOStudentSubmissionCount(totalCount: 1, totalPages: 1, list: data)
//        throw MyError.badNetwork
    }

    func getStudentLessons(studentId _: Int, page _: Int) async throws -> DTOStudentLessonsList {
        DTOStudentLessonsList(totalCount: 5, totalPages: 5, list: [
            .init(id: 1,
                  student: FullNameUser(id: 1, fullName: "", firstName: "", lastName: "",
                                        patronymic: "", mark: nil, avgMark: nil, quarterMarks: nil),
                  homework: 1,
                  submittedDate: "",
                  submittedOnTime: true,
                  mark: "",
                  lessonId: 1,
                  subject: SubjectName(id: 1, name: ""),
                  topic: ""),
        ])

//        throw MyError.badNetwork
    }
}

class MockPerformanceAPI: PerformanceAPIProtocol {
    private let studentMarks: [FullNameUser] = [
        .init(
            id: 71,
            fullName: "Соколов Игорь Станиславович",
            firstName: "Игорь",
            lastName: "Соколов",
            patronymic: "Станиславович",
            mark: nil,
            avgMark: nil,
            quarterMarks: nil
        ),
        .init(
            id: 72,
            fullName: "Попова Ольга Валентиновна",
            firstName: "Ольга",
            lastName: "Попова",
            patronymic: "Валентиновна",
            mark: nil,
            avgMark: nil,
            quarterMarks: nil
        ),
        .init(
            id: 73,
            fullName: "Новиков Николай Александрович",
            firstName: "Николай",
            lastName: "Новиков",
            patronymic: "Александрович",
            mark: nil,
            avgMark: nil,
            quarterMarks: nil
        ),
    ]

    func getGrades() async throws -> [GradeName] {
        [
            .init(id: 1, name: "5 A", subjects: nil),
            .init(id: 2, name: "5 Б", subjects: nil),
            .init(id: 3, name: "5 В", subjects: nil),
            .init(id: 4, name: "6 A", subjects: nil),
        ]
    }

    func getGradeDayData(gradeId _: Int, subjectId _: Int, date _: Date) async throws -> [FullNameUser] {
        studentMarks
    }

    func getGradeQuaterData(gradeId _: Int, subjectId _: Int) async throws -> [FullNameUser] {
        studentMarks
    }

    func setGradeForLesson(grade _: Grade, studentId _: Int, subjectId _: Int, date _: Date) async throws {
        throw MyError.badNetwork
    }

    func setGradeForQuater(grade _: Grade, studentId _: Int, subjectId _: Int, quater _: Quater) async throws {
        throw MyError.badNetwork
    }

    func getLastMarks(quater _: String) async throws -> [LastMarks?] {
        throw MyError.badNetwork
    }

    func getSubjectClassworkLastMarks(quater _: String, subjectId _: Int) async throws -> [StudentSubjectMark] {
        throw MyError.badNetwork
    }

    func getSubjectHomeworkLastMarks(quater _: String, subjectId _: Int) async throws -> [TeacherSubmission] {
        throw MyError.badNetwork
    }
}
