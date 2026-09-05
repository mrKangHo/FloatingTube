import Foundation

public struct ManageHistoryUseCase: Sendable {
    private let historyRepository: any HistoryRepositoryProtocol
    private let maxHistoryCount: Int
    
    public init(
        historyRepository: any HistoryRepositoryProtocol,
        maxHistoryCount: Int = 50
    ) {
        self.historyRepository = historyRepository
        self.maxHistoryCount = maxHistoryCount
    }
    
    public func loadHistory() -> [PlayHistoryItem] {
        return historyRepository.fetchHistory()
    }
    
    public func loadBookmarks() -> [PlayHistoryItem] {
        return historyRepository.fetchBookmarks()
    }
    
    public func addToHistory(
        target: YouTubeTarget,
        title: String,
        currentHistory: [PlayHistoryItem]
    ) -> [PlayHistoryItem] {
        var updated = currentHistory
        updated.removeAll { $0.target == target }
        let newItem = PlayHistoryItem(
            id: target.watchURLString,
            title: title,
            target: target,
            timestamp: Date()
        )
        updated.insert(newItem, at: 0)
        if updated.count > maxHistoryCount {
            updated = Array(updated.prefix(maxHistoryCount))
        }
        historyRepository.saveHistory(updated)
        return updated
    }
    
    public func toggleBookmark(
        target: YouTubeTarget,
        title: String,
        currentBookmarks: [PlayHistoryItem]
    ) -> (isBookmarked: Bool, bookmarks: [PlayHistoryItem]) {
        var updated = currentBookmarks
        if let index = updated.firstIndex(where: { $0.target == target }) {
            updated.remove(at: index)
            historyRepository.saveBookmarks(updated)
            return (false, updated)
        } else {
            let newItem = PlayHistoryItem(
                id: target.watchURLString,
                title: title.isEmpty ? "YouTube Video" : title,
                target: target,
                timestamp: Date(),
                isFavorite: true
            )
            updated.insert(newItem, at: 0)
            historyRepository.saveBookmarks(updated)
            return (true, updated)
        }
    }
    
    public func clearHistory() {
        historyRepository.clearHistory()
    }
}
