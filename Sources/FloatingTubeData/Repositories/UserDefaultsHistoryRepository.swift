import Foundation
import FloatingTubeDomain

public final class UserDefaultsHistoryRepository: HistoryRepositoryProtocol, @unchecked Sendable {
    private let userDefaults: UserDefaults
    private let historyKey: String
    private let bookmarksKey: String
    
    public init(
        userDefaults: UserDefaults = .standard,
        historyKey: String = "FloatingTube_History",
        bookmarksKey: String = "FloatingTube_Bookmarks"
    ) {
        self.userDefaults = userDefaults
        self.historyKey = historyKey
        self.bookmarksKey = bookmarksKey
    }
    
    public func fetchHistory() -> [PlayHistoryItem] {
        guard let data = userDefaults.data(forKey: historyKey),
              let items = try? JSONDecoder().decode([PlayHistoryItem].self, from: data) else {
            return []
        }
        return items
    }
    
    public func saveHistory(_ history: [PlayHistoryItem]) {
        if let encoded = try? JSONEncoder().encode(history) {
            userDefaults.set(encoded, forKey: historyKey)
        }
    }
    
    public func fetchBookmarks() -> [PlayHistoryItem] {
        guard let data = userDefaults.data(forKey: bookmarksKey),
              let items = try? JSONDecoder().decode([PlayHistoryItem].self, from: data) else {
            return []
        }
        return items
    }
    
    public func saveBookmarks(_ bookmarks: [PlayHistoryItem]) {
        if let encoded = try? JSONEncoder().encode(bookmarks) {
            userDefaults.set(encoded, forKey: bookmarksKey)
        }
    }
    
    public func clearHistory() {
        userDefaults.removeObject(forKey: historyKey)
    }
}
