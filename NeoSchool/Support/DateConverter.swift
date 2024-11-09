import UIKit

class DateConverter {

    static func convertDateStringToHoursAndMinutes(from dateString: String, dateFormat: DateFormat) throws -> String {
        let date = try getDateFromString(dateString: dateString, dateFormat: dateFormat)
        let timeString = getTimeFromDate(date: date)
        return timeString
    }

    static func convertDateStringToDay(from dateString: String, dateFormat: DateFormat) throws -> String {
        let date = try getDateFromString(dateString: dateString, dateFormat: dateFormat)
        let dayString = getDayFromDate(date: date, format: "dd.MM.yyyy")
        return dayString
    }

    static func convertDateStringToDayAndMonth(from dateString: String, dateFormat: DateFormat) throws -> String {
        let date = try getDateFromString(dateString: dateString, dateFormat: dateFormat)
        let dayString = getDayFromDate(date: date, format: "dd LLLL yyyy")
        return dayString
    }

    static func getDateFromString(dateString: String, dateFormat: DateFormat) throws -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat.rawValue
        guard let date = dateFormatter.date(from: dateString) else { throw MyError.invalidDateFormat }
        return date
    }

    static func getTimeFromDate(date: Date) -> String {
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "HH:mm"
        let timeString = timeFormatter.string(from: date)

        return timeString
    }

    static func getDayFromDate(date: Date, format: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        let dateString = dateFormatter.string(from: date)
        return dateString
    }
}
