import UIKit

class DateConverter {
    static func convertDateStringToHoursAndMinutes(from dateString: String, dateFormat: DateFormat) throws -> String {
        let date = try getDateFromString(dateString: dateString, dateFormat: dateFormat)
        return getTimeFromDate(date: date)
    }

    static func convertDateStringToDay(from dateString: String, dateFormat: DateFormat) throws -> String {
        let date = try getDateFromString(dateString: dateString, dateFormat: dateFormat)
        return getDayFromDate(date: date, format: "dd.MM.yyyy")
    }

    static func convertDateStringToDayAndMonth(from dateString: String, dateFormat: DateFormat) throws -> String {
        let date = try getDateFromString(dateString: dateString, dateFormat: dateFormat)
        return getDayFromDate(date: date, format: "dd LLLL yyyy")
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
        return timeFormatter.string(from: date)
    }

    static func getDayFromDate(date: Date, format: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: date)
    }
}
