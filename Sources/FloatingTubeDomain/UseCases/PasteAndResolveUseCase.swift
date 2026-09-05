import Foundation

public struct PasteAndResolveUseCase: Sendable {
    private let pasteboardService: any PasteboardServiceProtocol
    private let resolveTargetUseCase: ResolveYouTubeTargetUseCase
    
    public init(
        pasteboardService: any PasteboardServiceProtocol,
        resolveTargetUseCase: ResolveYouTubeTargetUseCase = ResolveYouTubeTargetUseCase()
    ) {
        self.pasteboardService = pasteboardService
        self.resolveTargetUseCase = resolveTargetUseCase
    }
    
    public func execute() -> (target: YouTubeTarget?, rawString: String?) {
        guard let copiedString = pasteboardService.getCopiedString(),
              !copiedString.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            return (nil, nil)
        }
        
        let target = resolveTargetUseCase.execute(copiedString)
        return (target, copiedString)
    }
}
