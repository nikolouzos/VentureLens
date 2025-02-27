import Foundation

public extension NumberFormatter {
    static let usdCurrency: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = Locale(identifier: "en-US")
        formatter.maximumFractionDigits = 0
        return formatter
    }()
    
    func string(from integer: Int?) -> String? {
        guard let integer else {
            return nil
        }
        return self.string(from: NSNumber(value: integer))
    }
}
