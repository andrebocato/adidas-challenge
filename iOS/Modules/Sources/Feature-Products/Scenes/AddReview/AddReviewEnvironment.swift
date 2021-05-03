import ComposableArchitecture
import Core_RepositoryInterface
import Foundation
import LightInjection

struct AddReviewEnvironment {
    
    var mainQueue: AnySchedulerOf<DispatchQueue>
    var locale: () -> String?
    var onSendReviewSuccess: () -> Void
    @Dependency var reviewRepository: ReviewRepositoryProtocol
    
    public init(
        mainQueue: AnySchedulerOf<DispatchQueue> = DispatchQueue.main.eraseToAnyScheduler(),
        locale: @escaping () -> String? = { Locale.autoupdatingCurrent.languageCode },
        onSendReviewSuccess: @escaping () -> Void
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
        onSendReviewSuccess: @escaping () -> Void = { },
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
