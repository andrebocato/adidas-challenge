import Foundation

protocol CurrencyFormatterProtocol {
    func format(_ value: Double, locale: String, currencyCode: String) -> String
}
extension CurrencyFormatterProtocol {
    func format(
        _ value: Double,
        locale: String = "nl-NL",
        currencyCode: String = "EUR"
    ) -> String {
        format(value, locale: locale, currencyCode: currencyCode)
    }
}

final class DefaultCurrencyFormatter: CurrencyFormatterProtocol {
    
    // MARK: - Dependencies

    private let numberFormatter: NumberFormatter

    // MARK: - Initializaters

    init(
        numberFormatter: NumberFormatter = .init()
    ) {
        self.numberFormatter = numberFormatter
    }

    // MARK: - Format Methods

    func format(_ value: Double, locale: String, currencyCode: String) -> String {
        numberFormatter.numberStyle = .currency
        numberFormatter.currencyCode = currencyCode
        numberFormatter.locale = Locale(identifier: locale)
        
        let formattedValue = numberFormatter.string(for: value) ?? "\(value)"
        return formattedValue
    }
}

#if DEBUG
    final class CurrencyFormatterDummy: CurrencyFormatterProtocol {
        func format(_ value: Double, locale: String, currencyCode: String) -> String { "" }
    }
#endif
