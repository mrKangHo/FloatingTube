import Foundation

public protocol HistoryRepositoryProtocol: AnyObject, Sendable {
    func fetchHistory() -> [PlayHistoryItem]
    func saveHistory(_ history: [PlayHistoryItem])
    func fetchBookmarks() -> [PlayHistoryItem]
    func saveBookmarks(_ bookmarks: [PlayHistoryItem])
    func clearHistory()
}
