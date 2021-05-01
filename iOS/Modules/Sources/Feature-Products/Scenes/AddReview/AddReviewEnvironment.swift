import ComposableArchitecture
import Core_RepositoryInterface
import Foundation
import LightInjection

struct AddReviewEnvironment {
    
    @Dependency var reviewRepository: ReviewRepositoryProtocol
    var mainQueue: AnySchedulerOf<DispatchQueue>
    var locale: () -> String?
    let onSendReviewSuccess: () -> Void
    
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
