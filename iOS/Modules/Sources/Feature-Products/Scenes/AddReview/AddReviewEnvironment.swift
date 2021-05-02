import ComposableArchitecture
import Core_RepositoryInterface
import Foundation
import LightInjection

struct AddReviewEnvironment {
    
    @Dependency var reviewRepository: ReviewRepositoryProtocol
    var mainQueue: AnySchedulerOf<DispatchQueue>
    var locale: () -> String?
    let onSendReviewSuccess: (Review?) -> Void
    
    public init(
        mainQueue: AnySchedulerOf<DispatchQueue> = DispatchQueue.main.eraseToAnyScheduler(),
        locale: @escaping () -> String? = { Locale.autoupdatingCurrent.languageCode },
        onSendReviewSuccess: @escaping (Review?) -> Void
    ) {
        self.mainQueue = mainQueue
        self.locale = locale
        self.onSendReviewSuccess = onSendReviewSuccess
    }
}

#if DEBUG
extension AddReviewEnvironment {
    static let dummy: Self = .mocking()
    
    static func mocking(
        mainQueue: AnySchedulerOf<DispatchQueue> = DispatchQueue.main.eraseToAnyScheduler(),
        locale: @escaping () -> String? = { Locale.autoupdatingCurrent.languageCode },
        onSendReviewSuccess: @escaping (Review?) -> Void = { _ in },
        reviewRepository: ReviewRepositoryProtocol = ReviewRepositoryDummy()
    ) -> Self {
        var instance: Self = .init(
            mainQueue: mainQueue,
            locale: locale,
            onSendReviewSuccess: onSendReviewSuccess
        )
        instance._reviewRepository = .resolved(reviewRepository)
        return instance
    }
}
#endif
