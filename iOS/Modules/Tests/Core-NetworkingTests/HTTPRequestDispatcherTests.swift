import Combine
@testable import Core_Networking
import Core_NetworkingInterface
import XCTest

final class HTTPRequestDispatcherTests: XCTestCase {
    
    // MARK: - Properties
    
    private let httpRequestDummy = HTTPRequestDummy()
    private let requestBuilderDummy = RequestBuilderDummy()
    
    // MARK: - Tests
    
    func test_dataPublisher_whenResponseIsValid_andResponseHTTPStatusIsInSuccessRange_shouldReturnResponseData() {
        // Given
        let validResponse: (data: Data, response: HTTPURLResponse) = (.init(), .fixture(statusCode: 200))
        let urlSessionStub = URLSessionStub()
        urlSessionStub.resultToBeReturned = .success(validResponse)
        
        let sut = HTTPRequestDispatcher(
            session: urlSessionStub,
            requestBuilder: requestBuilderDummy
        )
        
        var cancelBag = Set<AnyCancellable>()
        
        // When
        var receivedData: Data?
        let successExpectation = expectation(description: "Successfully received a response")
        sut.dataPublisher(for: httpRequestDummy)
            .sink(
                receiveCompletion: { result in
                    switch result {
                    case let .failure(error):
                        XCTFail("Expected success, got error: \(error.localizedDescription)")
                    case .finished:
                        cancelBag.removeAll()
                    }
                },
                receiveValue: { data in
                    successExpectation.fulfill()
                    receivedData = data
                }
            )
            .store(in: &cancelBag)
        
        // Then
        wait(for: [successExpectation], timeout: 1)
        XCTAssertNotNil(receivedData)
    }
    
    func test_dataPublisher_whenResponseIsInvalid_shouldReturnInvalidHTTPResponseError() {
        // Given
        let invalidResponse: (data: Data, response: URLResponse) = (.init(), .init()) // Not a HTTPURLResponse
        let urlSessionStub = URLSessionStub()
        urlSessionStub.resultToBeReturned = .success(invalidResponse)
        
        let sut = HTTPRequestDispatcher(
            session: urlSessionStub,
            requestBuilder: requestBuilderDummy
        )
        
        var cancelBag = Set<AnyCancellable>()
        
        // When
        var receivedError: HTTPRequestError?
        let failureExpectation = expectation(description: "Failed successfully")
        sut.dataPublisher(for: httpRequestDummy)
            .sink(
                receiveCompletion: { result in
                    switch result {
                    case let .failure(error):
                        failureExpectation.fulfill()
                        receivedError = error
                        
                    case .finished:
                        cancelBag.removeAll()
                    }
                },
                receiveValue: { data in
                    XCTFail("Expected failure, got success with data: \(data)")
                }
            )
            .store(in: &cancelBag)
        
        // Then
        wait(for: [failureExpectation], timeout: 1)
        XCTAssertEqual(receivedError, .invalidHTTPResponse)
    }
    
    func test_dataPublisher_whenResponseHTTPStatusIsNotInSuccessRange_shouldReturnDataTaskError() {
        // Given
        let responseOutOfSuccessRange: (data: Data, response: HTTPURLResponse) = (.init(), .fixture(statusCode: 400))
        let urlSessionStub = URLSessionStub()
        urlSessionStub.resultToBeReturned = .success(responseOutOfSuccessRange)
        
        let sut = HTTPRequestDispatcher(
            session: urlSessionStub,
            requestBuilder: requestBuilderDummy
        )
        let expectedError: HTTPRequestError = .yielding(
            data: responseOutOfSuccessRange.data,
            statusCode: responseOutOfSuccessRange.response.statusCode
        )
        
        var cancelBag = Set<AnyCancellable>()
        
        // When
        var receivedError: HTTPRequestError?
        let failureExpectation = expectation(description: "Failed successfully")
        sut.dataPublisher(for: httpRequestDummy)
            .sink(
                receiveCompletion: { result in
                    switch result {
                    case let .failure(error):
                        failureExpectation.fulfill()
                        receivedError = error
                        
                    case .finished:
                        cancelBag.removeAll()
                    }
                },
                receiveValue: { data in
                    XCTFail("Expected failure, got success with data: \(data)")
                }
            )
            .store(in: &cancelBag)
        
        // Then
        wait(for: [failureExpectation], timeout: 1)
        XCTAssertEqual(receivedError, expectedError)
    }
    
    // @FIXME: fix this test and enable it. We should mock a URLError where networkUnavailableReason is not nil to make it pass again.
    func test_dataPublisher_whenConnectionErrorOccurs_shouldReturnUnreachableNetworkError() {
        // Given
        let reachabilityError: URLError = .init(.networkConnectionLost)
        let urlSessionStub = URLSessionStub()
        urlSessionStub.resultToBeReturned = .failure(reachabilityError)
        
        var constrainedNetworkURLRequest: URLRequest = .init(url: .dummy())
        constrainedNetworkURLRequest.allowsConstrainedNetworkAccess = false
        let requestBuilderStub = RequestBuilderStub()
        requestBuilderStub.buildResultToBeReturned = .success(constrainedNetworkURLRequest)
                
        let sut = HTTPRequestDispatcher(
            session: urlSessionStub,
            requestBuilder: requestBuilderStub
        )
        
        var cancelBag = Set<AnyCancellable>()
        
        // When
        var receivedError: HTTPRequestError?
        let failureExpectation = expectation(description: "Failed successfully")
        sut.dataPublisher(for: httpRequestDummy)
            .sink(
                receiveCompletion: { result in
                    switch result {
                    case let .failure(error):
                        failureExpectation.fulfill()
                        receivedError = error
                        
                    case .finished:
                        cancelBag.removeAll()
                    }
                },
                receiveValue: { data in
                    XCTFail("Expected failure, got success with data: \(data)")
                }
            )
            .store(in: &cancelBag)
        
        // Then
        wait(for: [failureExpectation], timeout: 1)
        XCTAssertEqual(receivedError, .unreachableNetwork)
    }
    
    func test_dataPublisher_whenAnyHTTPRequestErrorOccurs_shouldReturnErrorOfTypeHTTPRequestError() {
        // Given
        let anyHTTPRequestError: HTTPRequestError = .invalidHTTPResponse // Any error goes
        let urlSessionStub = URLSessionStub()
        urlSessionStub.resultToBeReturned = .failure(anyHTTPRequestError)
        
        let sut = HTTPRequestDispatcher(
            session: urlSessionStub,
            requestBuilder: requestBuilderDummy
        )
        
        var cancelBag = Set<AnyCancellable>()
        
        // When
        var receivedError: Error?
        let failureExpectation = expectation(description: "Failed successfully")
        sut.dataPublisher(for: httpRequestDummy)
            .sink(
                receiveCompletion: { result in
                    switch result {
                    case let .failure(error):
                        failureExpectation.fulfill()
                        receivedError = error
                        
                    case .finished:
                        cancelBag.removeAll()
                    }
                },
                receiveValue: { data in
                    XCTFail("Expected failure, got success with data: \(data)")
                }
            )
            .store(in: &cancelBag)
        
        // Then
        wait(for: [failureExpectation], timeout: 1)
        XCTAssert(receivedError is HTTPRequestError)

    }
        
    func test_dataPublisher_whenURLSessionErrorOccurs_shouldReturnURLError() {
        // Given
        let anyURLSessionError: URLError = .init(.badURL)
        let urlSessionStub = URLSessionStub()
        urlSessionStub.resultToBeReturned = .failure(anyURLSessionError)
        
        let sut = HTTPRequestDispatcher(
            session: urlSessionStub,
            requestBuilder: requestBuilderDummy
        )
        let expectedError: HTTPRequestError = .urlError(anyURLSessionError)
        
        var cancelBag = Set<AnyCancellable>()
        
        // When
        var receivedError: HTTPRequestError?
        let failureExpectation = expectation(description: "Failed successfully")
        sut.dataPublisher(for: httpRequestDummy)
            .sink(
                receiveCompletion: { result in
                    switch result {
                    case let .failure(error):
                        failureExpectation.fulfill()
                        receivedError = error
                        
                    case .finished:
                        cancelBag.removeAll()
                    }
                },
                receiveValue: { data in
                    XCTFail("Expected failure, got success with data: \(data)")
                }
            )
            .store(in: &cancelBag)
        
        // Then
        wait(for: [failureExpectation], timeout: 1)
        XCTAssertEqual(receivedError, expectedError)
    }
    
    func test_dataPublisher_whenAnUncatecorizegErrorOccurs_shouldReturnNetworkingError() {
        // Given
        let anyError: NSError = .init(domain: "", code: -1)
        let urlSessionStub = URLSessionStub()
        urlSessionStub.resultToBeReturned = .failure(anyError)
        
        let sut = HTTPRequestDispatcher(
            session: urlSessionStub,
            requestBuilder: requestBuilderDummy
        )
        let expectedError: HTTPRequestError = .networking(anyError)
        
        var cancelBag = Set<AnyCancellable>()
        
        // When
        var receivedError: HTTPRequestError?
        let failureExpectation = expectation(description: "Failed successfully")
        sut.dataPublisher(for: httpRequestDummy)
            .sink(
                receiveCompletion: { result in
                    switch result {
                    case let .failure(error):
                        failureExpectation.fulfill()
                        receivedError = error
                        
                    case .finished:
                        cancelBag.removeAll()
                    }
                },
                receiveValue: { data in
                    XCTFail("Expected failure, got success with data: \(data)")
                }
            )
            .store(in: &cancelBag)
        
        // Then
        wait(for: [failureExpectation], timeout: 1)
        XCTAssertEqual(receivedError, expectedError)
    }

    func test_dataPublisher_whenSerializationFails_shouldReturnSerializationError() {
        // Given
        let serializationError: NSError = .init(domain: "", code: -1)
        let requestBuilderStub = RequestBuilderStub()
        requestBuilderStub.buildResultToBeReturned = .failure(serializationError)

        let sut = HTTPRequestDispatcher(
            session: URLSessionDummy(),
            requestBuilder: requestBuilderStub
        )
        let expectedError: HTTPRequestError = .requestSerialization(serializationError)

        var cancelBag = Set<AnyCancellable>()

        // When
        var receivedError: HTTPRequestError?
        let failureExpectation = expectation(description: "Failed successfully")
        sut.dataPublisher(for: httpRequestDummy)
            .sink(
                receiveCompletion: { result in
                    switch result {
                    case let .failure(error):
                        failureExpectation.fulfill()
                        receivedError = error

                    case .finished:
                        cancelBag.removeAll()
                    }
                },
                receiveValue: { data in
                    XCTFail("Expected failure, got success with data: \(data)")
                }
            )
            .store(in: &cancelBag)

        // Then
        wait(for: [failureExpectation], timeout: 1)
        XCTAssertEqual(receivedError, expectedError)
    }
}

// MARK: - Test Helpers

extension HTTPURLResponse {
    static func fixture(
        url: URL = .dummy(),
        statusCode: Int = -1,
        httpVersion: String? = nil,
        headerFields: [String: String]? = nil
    ) -> HTTPURLResponse {
        guard let fixture = HTTPURLResponse(
            url: url,
            statusCode: statusCode,
            httpVersion: httpVersion,
            headerFields: headerFields
        ) else {
            preconditionFailure("This should have never failed...")
        }
        return fixture
    }
}
