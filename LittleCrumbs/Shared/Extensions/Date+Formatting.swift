import Foundation

extension Date {
    var weekdayTimeString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, h:mm a"
        return formatter.string(from: self)
    }
}
