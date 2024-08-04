import Foundation


class MockNotificationsAPI: NotificationsNetworkAPIProtocol {

    func getNotifications(page: Int, limit: Int) async throws -> DTONotifications {
        let data = DTONotifications(total_count: 5, total_pages: 1, list: [
            .init(id: 1, createdAt: Date(), updatedAt: Date(), sender: 1,
                  extraData: ExtraData.classworkRate(mark: "5", subject: "Биология", subjectId: 1),
                  title: "Вы получили оценку 5 по предмету Биология", description: "Тестовое описание",
                  isRead: false, type: NotificationType.rate_classwork),
            .init(id: 2, createdAt: Date(), updatedAt: Date(), sender: 1,
                  extraData: ExtraData.classworkRate(mark: "4", subject: "Математика", subjectId: 2),
                  title: "Вы получили оценку 4 по предмету Математика", description: "Тестовое описание",
                  isRead: false, type: NotificationType.rate_classwork),
            .init(id: 3, createdAt: Date(), updatedAt: Date(), sender: 1,
                  extraData: ExtraData.classworkRate(mark: "3", subject: "Физика", subjectId: 3),
                  title: "Вы получили оценку 3 по предмету Физика", description: "Тестовое описание",
                  isRead: false, type: NotificationType.rate_classwork),
            .init(id: 4, createdAt: Date(), updatedAt: Date(), sender: 1,
                  extraData: ExtraData.classworkRate(mark: "2", subject: "География", subjectId: 4),
                  title: "Вы получили оценку 2 по предмету География", description: "Тестовое описание",
                  isRead: true, type: NotificationType.rate_classwork),
            .init(id: 5, createdAt: Date(), updatedAt: Date(), sender: 1,
                  extraData: ExtraData.classworkRate(mark: "5", subject: "Английский", subjectId: 5),
                  title: "Вы получили оценку 5 по предмету Английский", description: "Тестовое описание",
                  isRead: false, type: NotificationType.rate_classwork),
            .init(id: 6, createdAt: Date(), updatedAt: Date(), sender: 1,
                  extraData: ExtraData.classworkRate(mark: "4", subject: "Кыргызский", subjectId: 6),
                  title: "Вы получили оценку 4 по предмету Кыргызский", description: "Тестовое описание",
                  isRead: false, type: NotificationType.rate_classwork),
            .init(id: 7, createdAt: Date(), updatedAt: Date(), sender: 1,
                  extraData: ExtraData.classworkRate(mark: "5", subject: "Геометрия", subjectId: 7),
                  title: "Вы получили оценку 5 по предмету Геометрия", description: "Тестовое описание",
                  isRead: false, type: NotificationType.rate_classwork),
            .init(id: 8, createdAt: Date(), updatedAt: Date(), sender: 1,
                  extraData: ExtraData.classworkRate(mark: "3", subject: "Физкультура", subjectId: 8),
                  title: "Вы получили оценку 3 по предмету Физкультура", description: "Тестовое описание",
                  isRead: true, type: NotificationType.rate_classwork)
        ])

        return data
    }
}


class MockTeacherDayScheduleAPI: TeacherLessonDayProtocol {
    func getLessons(forDayId dayId: Int, userRole: UserRole) async throws -> [SchoolLesson] {
        return [
            .init(id: 1, day: Day(id: 1, name: "Пн"), room: Room(id: 1, name: "302"), subject: SubjectName(id: 1, name: "Биология"), homework: nil, startTime: "2012-01-26T13:51:50.417-07:00", endTime: "2012-01-26T13:51:50.417-07:00", mark: nil, homeworkCount: nil, grade: nil),
            .init(id: 1, day: Day(id: 1, name: "Пн"), room: Room(id: 1, name: "302"), subject: SubjectName(id: 1, name: "Физика"), homework: nil, startTime: "2012-01-26T13:51:50.417-07:00", endTime: "2012-01-26T13:51:50.417-07:00", mark: nil, homeworkCount: nil, grade: nil),
            .init(id: 1, day: Day(id: 1, name: "Пн"), room: Room(id: 1, name: "302"), subject: SubjectName(id: 1, name: "Химия"), homework: nil, startTime: "2012-01-26T13:51:50.417-07:00", endTime: "2012-01-26T13:51:50.417-07:00", mark: nil, homeworkCount: nil, grade: nil),
            .init(id: 1, day: Day(id: 1, name: "Пн"), room: Room(id: 1, name: "302"), subject: SubjectName(id: 1, name: "Математика"), homework: nil, startTime: "2012-01-26T13:51:50.417-07:00", endTime: "2012-01-26T13:51:50.417-07:00", mark: nil, homeworkCount: nil, grade: nil),
        ]
    }
    
    func getTeacherLessonDetail(forLessonId lessonId: Int) async throws -> TeacherLessonDetail {
        return TeacherLessonDetail(id: 1, subject: StudentSubject(id: 1, name: "Биология", teacher: FullNameUser(id: 1, fullName: "Петрова Ольга Викторовна", firstName: "Ольга", lastName: "Петрова", patronymic: "Петрова О.В.")), homework: TeacherHomework(id: 1, text: "Прочитать главу 3", deadline: "2012-01-26T08:40:00.000+06:00", filesCount: 1), submissions: nil, grade: GradeName(id: 1, name: "5"), room: Room(id: 1, name: "301"), startTime: "2012-01-26T08:00:00.000+06:00", endTime: "2012-01-26T08:40:00.000+06:00", studentCount: 15)
    }
    
    func getStudentList(subjectId: Int, gradeId: Int, page: Int) async throws -> [StudentSubmissionCount] {
        let data : [StudentSubmissionCount] = [
            .init(id: 1, fullName: "Березин Артем Игоервич", firstName: "Артем", lastName: "Березин", patronymic: "Березин А.И.", submissionsCount: "0"),
            .init(id: 2, fullName: "Ревзин Иван Александрович", firstName: "Иван", lastName: "Ревзин", patronymic: "Ревизн И.А.", submissionsCount: "6"),
            .init(id: 3, fullName: "Щетинин Денис Александрович", firstName: "Денис", lastName: "Щетинин", patronymic: "Щетинин Д.А.", submissionsCount: "3"),
            .init(id: 4, fullName: "Иванов Иван Иванович", firstName: "Иван", lastName: "Иванов", patronymic: "Иванов И.И.", submissionsCount: "4"),
            .init(id: 5, fullName: "Иванов Иван Иванович", firstName: "Иван", lastName: "Иванов", patronymic: "Иванов И.И.", submissionsCount: "4"),
            .init(id: 6, fullName: "Иванов Иван Иванович", firstName: "Иван", lastName: "Иванов", patronymic: "Иванов И.И.", submissionsCount: "4"),
            .init(id: 7, fullName: "Иванов Иван Иванович", firstName: "Иван", lastName: "Иванов", patronymic: "Иванов И.И.", submissionsCount: "4"),
            .init(id: 8, fullName: "Иванов Иван Иванович", firstName: "Иван", lastName: "Иванов", patronymic: "Иван И.И.", submissionsCount: "4"),
            .init(id: 9, fullName: "Иванов Иван Иванович", firstName: "Иван", lastName: "Иванов", patronymic: "Иванов И.И.", submissionsCount: "4"),
            .init(id: 10, fullName: "Иванов Иван Иванович", firstName: "Иван", lastName: "Иванов", patronymic: "Иванов И.И.", submissionsCount: "4"),
            .init(id: 11, fullName: "Иванов Иван Иванович", firstName: "Иван", lastName: "Иванов", patronymic: "Иванов И.И.", submissionsCount: "4"),

        ]

        return data
    }
    


}