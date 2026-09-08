import Foundation

public enum YouTubeTarget: Equatable, Codable, Sendable {
    case video(id: String, startTime: Int? = nil, playlistId: String? = nil)
    case playlist(id: String)
    case direct(url: URL)
    
    public var embedURL: URL? {
        switch self {
        case .video(let id, let startTime, let playlistId):
            var components = URLComponents(string: "https://www.youtube-nocookie.com/embed/\(id)")
            var queryItems = [
                URLQueryItem(name: "enablejsapi", value: "1"),
                URLQueryItem(name: "autoplay", value: "1"),
                URLQueryItem(name: "playsinline", value: "1"),
                URLQueryItem(name: "modestbranding", value: "1"),
                URLQueryItem(name: "rel", value: "0"),
                URLQueryItem(name: "iv_load_policy", value: "3"),
                URLQueryItem(name: "origin", value: "https://www.youtube.com")
            ]
            if let start = startTime, start > 0 {
                queryItems.append(URLQueryItem(name: "start", value: "\(start)"))
            }
            if let list = playlistId, !list.isEmpty {
                queryItems.append(URLQueryItem(name: "list", value: list))
            }
            components?.queryItems = queryItems
            return components?.url
            
        case .playlist(let id):
            var components = URLComponents(string: "https://www.youtube-nocookie.com/embed/videoseries")
            components?.queryItems = [
                URLQueryItem(name: "list", value: id),
                URLQueryItem(name: "enablejsapi", value: "1"),
                URLQueryItem(name: "autoplay", value: "1"),
                URLQueryItem(name: "playsinline", value: "1"),
                URLQueryItem(name: "origin", value: "https://www.youtube.com")
            ]
            return components?.url
            
        case .direct(let url):
            return url
        }
    }
    
    public var watchURLString: String {
        switch self {
        case .video(let id, let startTime, let playlistId):
            var str = "https://www.youtube.com/watch?v=\(id)"
            if let playlistId = playlistId, !playlistId.isEmpty {
                str += "&list=\(playlistId)"
            }
            if let startTime = startTime, startTime > 0 {
                str += "&t=\(startTime)s"
            }
            return str
        case .playlist(let id):
            return "https://www.youtube.com/playlist?list=\(id)"
        case .direct(let url):
            return url.absoluteString
        }
    }
}
