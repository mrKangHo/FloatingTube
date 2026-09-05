import Testing
import Foundation
import FloatingTubeDomain

final class MockHistoryRepository: HistoryRepositoryProtocol, @unchecked Sendable {
    var storedHistory: [PlayHistoryItem] = []
    var storedBookmarks: [PlayHistoryItem] = []
    
    func fetchHistory() -> [PlayHistoryItem] {
        return storedHistory
    }
    
    func saveHistory(_ history: [PlayHistoryItem]) {
        self.storedHistory = history
    }
    
    func fetchBookmarks() -> [PlayHistoryItem] {
        return storedBookmarks
    }
    
    func saveBookmarks(_ bookmarks: [PlayHistoryItem]) {
        self.storedBookmarks = bookmarks
    }
    
    func clearHistory() {
        self.storedHistory.removeAll()
    }
}

@Suite("ManageHistoryUseCase Tests")
struct ManageHistoryUseCaseTests {
    @Test("Add item to history moves it to front and saves")
    func testAddToHistory() {
        let repo = MockHistoryRepository()
        let useCase = ManageHistoryUseCase(historyRepository: repo, maxHistoryCount: 50)
        
        let target1 = YouTubeTarget.video(id: "video_11111")
        let target2 = YouTubeTarget.video(id: "video_22222")
        
        var history: [PlayHistoryItem] = []
        history = useCase.addToHistory(target: target1, title: "Title 1", currentHistory: history)
        #expect(history.count == 1)
        #expect(history.first?.id == target1.watchURLString)
        
        history = useCase.addToHistory(target: target2, title: "Title 2", currentHistory: history)
        #expect(history.count == 2)
        #expect(history.first?.id == target2.watchURLString)
        
        // Re-adding target1 should move it to the front without duplicates
        history = useCase.addToHistory(target: target1, title: "Title 1 Updated", currentHistory: history)
        #expect(history.count == 2)
        #expect(history.first?.id == target1.watchURLString)
        #expect(history.first?.title == "Title 1 Updated")
        
        #expect(repo.storedHistory == history)
    }
    
    @Test("History is capped at maxHistoryCount")
    func testMaxHistoryLimit() {
        let repo = MockHistoryRepository()
        let maxLimit = 5
        let useCase = ManageHistoryUseCase(historyRepository: repo, maxHistoryCount: maxLimit)
        
        var history: [PlayHistoryItem] = []
        for i in 1...10 {
            let target = YouTubeTarget.video(id: "video_\(i)")
            history = useCase.addToHistory(target: target, title: "Title \(i)", currentHistory: history)
        }
        
        #expect(history.count == maxLimit)
        #expect(history.first?.id.contains("video_10") == true)
    }
    
    @Test("Toggle bookmark adds and removes item")
    func testToggleBookmark() {
        let repo = MockHistoryRepository()
        let useCase = ManageHistoryUseCase(historyRepository: repo)
        let target = YouTubeTarget.video(id: "bookmark_1")
        
        let bookmarks: [PlayHistoryItem] = []
        
        // 1. Add bookmark
        let (isBookmarked1, updated1) = useCase.toggleBookmark(target: target, title: "Bookmark Video", currentBookmarks: bookmarks)
        #expect(isBookmarked1 == true)
        #expect(updated1.count == 1)
        #expect(repo.storedBookmarks.count == 1)
        
        // 2. Remove bookmark
        let (isBookmarked2, updated2) = useCase.toggleBookmark(target: target, title: "Bookmark Video", currentBookmarks: updated1)
        #expect(isBookmarked2 == false)
        #expect(updated2.isEmpty)
        #expect(repo.storedBookmarks.isEmpty)
    }
    
    @Test("Clear history removes all history items")
    func testClearHistory() {
        let repo = MockHistoryRepository()
        let useCase = ManageHistoryUseCase(historyRepository: repo)
        repo.storedHistory = [
            PlayHistoryItem(id: "1", title: "A", target: .video(id: "1")),
            PlayHistoryItem(id: "2", title: "B", target: .video(id: "2"))
        ]
        
        useCase.clearHistory()
        #expect(repo.storedHistory.isEmpty)
    }
}
