import Foundation

public protocol CurrencyFormatterProtocol {
    func format(_ value: Double, locale: String, currencyCode: String) -> String
}
extension CurrencyFormatterProtocol {
    public func format(
        _ value: Double,
        locale: String = "en-NL",
        currencyCode: String = "EUR"
    ) -> String {
        format(value, locale: locale, currencyCode: currencyCode)
    }
}

public final class DefaultCurrencyFormatter: CurrencyFormatterProtocol {
    
    // MARK: - Dependencies
    
    private let numberFormatter: NumberFormatter
    
    // MARK: - Initializaters
    
    public init(
        numberFormatter: NumberFormatter = .init()
    ) {
        self.numberFormatter = numberFormatter
    }
    
    // MARK: - Format Methods
    
    public func format(_ value: Double, locale: String, currencyCode: String) -> String {
        numberFormatter.numberStyle = .currency
        numberFormatter.currencyCode = currencyCode
        numberFormatter.locale = Locale(identifier: locale)
        
        let formattedValue = numberFormatter.string(for: value) ?? "\(value)"
        return formattedValue
    }
}

#if DEBUG
public struct CurrencyFormatterDummy: CurrencyFormatterProtocol {
    public init() { }
    public func format(_ value: Double, locale: String, currencyCode: String) -> String { "" }
}
#endif
