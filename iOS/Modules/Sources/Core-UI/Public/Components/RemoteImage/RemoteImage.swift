import Combine
import Foundation
import SwiftUI

public struct RemoteImage: View {
    
    // MARK: - Dependencies
    
    @ObservedObject private var imageLoader: ImageLoader

    // MARK: - Properties
    
    private let url: URL
    private var placeholder: AnyView = .init(Color.clear)
    private let cancelOnDisapear: Bool

    // MARK: - Initialization
    
    init(
        imageLoader: ImageLoader,
        url: URL,
        cancelOnDisapear: Bool
    ) {
        self.imageLoader = imageLoader
        self.url = url
        self.cancelOnDisapear = cancelOnDisapear
        imageLoader.loadData(for: url)
    }

    public init(
        url: URL,
        cancelOnDisapear: Bool = false
    ) {
        self.init(
            imageLoader: ImageLoader(),
            url: url,
            cancelOnDisapear: cancelOnDisapear
        )
    }

    // MARK: - View
    
    public var body: some View {
        Group {
            switch imageLoader.state {
            case .empty:
                placeholder
            case .loading:
                ActivityIndicator(style: .medium)
            case let .loaded(imageData):
                if let uiImage = UIImage(data: imageData) {
                    Image(uiImage: uiImage)
                        .resizable()
                } else {
                    placeholder
                }
            }
        }
        .onDisappear {
            guard cancelOnDisapear else { return }
            imageLoader.cancel()
        }
        .scaledToFill()
        .clipped()
    }

    // MARK: - Public API
    
    public mutating func setPlaceholder<Placeholder: View>(@ViewBuilder placeholder: () -> Placeholder) -> some View {
        self.placeholder = .init(placeholder())
        return self
    }
}
