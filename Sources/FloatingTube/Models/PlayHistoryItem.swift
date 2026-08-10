import Foundation

public struct PlayHistoryItem: Identifiable, Codable, Equatable {
    public var id: String // Video ID or URL string
    public var title: String
    public var target: YouTubeTarget
    public var timestamp: Date
    public var isFavorite: Bool
    
    public init(id: String, title: String, target: YouTubeTarget, timestamp: Date = Date(), isFavorite: Bool = false) {
        self.id = id
        self.title = title
        self.target = target
        self.timestamp = timestamp
        self.isFavorite = isFavorite
    }
}
