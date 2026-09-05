import Testing
import Foundation
import FloatingTubeDomain

struct MockPasteboardService: PasteboardServiceProtocol {
    let mockString: String?
    
    func getCopiedString() -> String? {
        return mockString
    }
}

@Suite("PasteAndResolveUseCase Tests")
struct PasteAndResolveUseCaseTests {
    @Test("Valid YouTube URL in pasteboard returns resolved target")
    func testValidClipboardURL() {
        let service = MockPasteboardService(mockString: "https://youtu.be/dQw4w9WgXcQ")
        let useCase = PasteAndResolveUseCase(pasteboardService: service)
        
        let result = useCase.execute()
        #expect(result.target == .video(id: "dQw4w9WgXcQ"))
        #expect(result.rawString == "https://youtu.be/dQw4w9WgXcQ")
    }
    
    @Test("Empty clipboard returns nil target and nil rawString")
    func testEmptyClipboard() {
        let service = MockPasteboardService(mockString: nil)
        let useCase = PasteAndResolveUseCase(pasteboardService: service)
        
        let result = useCase.execute()
        #expect(result.target == nil)
        #expect(result.rawString == nil)
    }
}
