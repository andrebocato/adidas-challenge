import Foundation
import Combine

public protocol HTTPRequestDispatcherProtocol {
    func dataPublisher(for request: HTTPRequestProtocol) -> AnyPublisher<Data, HTTPRequestError>
}
