import Core
import SwiftUI

public struct CachedAsyncImage<Content: View, Placeholder: View, Failure: View>: View {
    private let url: URL?
    private let scale: CGFloat
    private let transaction: Transaction
    private let content: (Image) -> Content
    private let placeholder: () -> Placeholder
    private let failure: ((Error) -> Failure)?
    
    @State private var imagePhase: AsyncImagePhase = .empty
    
    public init(
        url: URL?,
        scale: CGFloat = 1.0,
        transaction: Transaction = Transaction(),
        @ViewBuilder content: @escaping (Image) -> Content,
        @ViewBuilder placeholder: @escaping () -> Placeholder,
        @ViewBuilder failure: @escaping (Error) -> Failure
    ) {
        self.url = url
        self.scale = scale
        self.transaction = transaction
        self.content = content
        self.placeholder = placeholder
        self.failure = failure
    }
    
    public init(
        url: URL?,
        scale: CGFloat = 1.0,
        transaction: Transaction = Transaction(),
        @ViewBuilder content: @escaping (Image) -> Content,
        @ViewBuilder placeholder: @escaping () -> Placeholder
    ) where Failure == Placeholder {
        self.url = url
        self.scale = scale
        self.transaction = transaction
        self.content = content
        self.placeholder = placeholder
        self.failure = nil
    }
    
    public var body: some View {
        Group {
            switch imagePhase {
            case .empty:
                placeholder()
                    .task {
                        await loadImage()
                    }
                
            case .success(let image):
                content(image)
                
            case .failure(let error):
                if let failure = failure {
                    failure(error)
                } else {
                    placeholder()
                }
                
            @unknown default:
                placeholder()
            }
        }
    }
    
    private func loadImage() async {
        guard let url = url else { return }
        
        // Check cache first
        if let cachedImage = await ImageCache.shared.image(for: url.absoluteString) {
            imagePhase = .success(Image(uiImage: cachedImage))
            return
        }
        
        // If not in cache, load from network
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            guard let image = UIImage(data: data) else {
                throw URLError(.cannotDecodeContentData)
            }
            
            // Cache the image
            await ImageCache.shared.insertImage(image, for: url.absoluteString)
            
            withTransaction(transaction) {
                imagePhase = .success(Image(uiImage: image))
            }
        } catch {
            withTransaction(transaction) {
                imagePhase = .failure(error)
            }
        }
    }
}
