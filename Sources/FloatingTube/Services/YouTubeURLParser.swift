import Foundation

public enum YouTubeTarget: Equatable, Codable {
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

public struct YouTubeURLParser {
    
    /// Parses any user input string (URL, Shorts, Embed, Video ID, Playlist, or Search) into a YouTubeTarget
    public static func parse(_ input: String) -> YouTubeTarget? {
        let trimmed = input.trimmingCharacters(in: .whitespacesAndNewlines)
        if trimmed.isEmpty { return nil }
        
        // 1. Direct 11-char Video ID match (e.g. "dQw4w9WgXcQ")
        let videoIdRegex = try? NSRegularExpression(pattern: "^[a-zA-Z0-9_-]{11}$")
        if let regex = videoIdRegex, regex.firstMatch(in: trimmed, range: NSRange(location: 0, length: trimmed.utf16.count)) != nil {
            return .video(id: trimmed)
        }
        
        // Ensure scheme for URL parsing
        var urlString = trimmed
        if !urlString.lowercased().hasPrefix("http://") && !urlString.lowercased().hasPrefix("https://") {
            urlString = "https://" + urlString
        }
        
        guard let url = URL(string: urlString), let host = url.host?.lowercased() else {
            return nil
        }
        
        // Check if YouTube domain
        let isYouTube = host.contains("youtube.com") || host.contains("youtu.be") || host.contains("youtube-nocookie.com")
        
        if !isYouTube {
            // If it's a general web link, return as direct URL
            return .direct(url: url)
        }
        
        let path = url.path
        let queryParams = parseQueryParams(url: url)
        let startTime = parseStartTime(queryParams: queryParams)
        let playlistId = queryParams["list"]
        
        // Case: youtu.be/VIDEO_ID
        if host.contains("youtu.be") {
            let id = path.trimmingCharacters(in: CharacterSet(charactersIn: "/"))
            if !id.isEmpty {
                return .video(id: id, startTime: startTime, playlistId: playlistId)
            }
        }
        
        // Case: youtube.com/shorts/VIDEO_ID
        if path.hasPrefix("/shorts/") {
            let id = path.replacingOccurrences(of: "/shorts/", with: "").components(separatedBy: "/").first ?? ""
            if !id.isEmpty {
                return .video(id: id, startTime: startTime, playlistId: playlistId)
            }
        }
        
        // Case: youtube.com/live/VIDEO_ID
        if path.hasPrefix("/live/") {
            let id = path.replacingOccurrences(of: "/live/", with: "").components(separatedBy: "/").first ?? ""
            if !id.isEmpty {
                return .video(id: id, startTime: startTime, playlistId: playlistId)
            }
        }
        
        // Case: youtube.com/embed/VIDEO_ID
        if path.hasPrefix("/embed/") {
            let id = path.replacingOccurrences(of: "/embed/", with: "").components(separatedBy: "/").first ?? ""
            if id == "videoseries", let list = playlistId {
                return .playlist(id: list)
            }
            if !id.isEmpty {
                return .video(id: id, startTime: startTime, playlistId: playlistId)
            }
        }
        
        // Case: youtube.com/watch?v=VIDEO_ID
        if let videoId = queryParams["v"], !videoId.isEmpty {
            return .video(id: videoId, startTime: startTime, playlistId: playlistId)
        }
        
        // Case: youtube.com/playlist?list=PLAYLIST_ID
        if let listId = playlistId, !listId.isEmpty {
            return .playlist(id: listId)
        }
        
        return .direct(url: url)
    }
    
    private static func parseQueryParams(url: URL) -> [String: String] {
        guard let components = URLComponents(url: url, resolvingAgainstBaseURL: false),
              let queryItems = components.queryItems else {
            return [:]
        }
        var dict: [String: String] = [:]
        for item in queryItems {
            dict[item.name] = item.value
        }
        return dict
    }
    
    private static func parseStartTime(queryParams: [String: String]) -> Int? {
        if let t = queryParams["t"] ?? queryParams["start"] {
            // Can be "120", "120s", "1m30s", "1h2m3s"
            if let seconds = Int(t.replacingOccurrences(of: "s", with: "")) {
                return seconds
            }
            // Parse 1h20m30s
            var total = 0
            let scanner = Scanner(string: t)
            var currentNumber: Int = 0
            while !scanner.isAtEnd {
                if let num = scanner.scanInt() {
                    currentNumber = num
                    if let unit = scanner.scanCharacter() {
                        if unit == "h" || unit == "H" {
                            total += currentNumber * 3600
                        } else if unit == "m" || unit == "M" {
                            total += currentNumber * 60
                        } else if unit == "s" || unit == "S" {
                            total += currentNumber
                        }
                    } else {
                        total += currentNumber
                    }
                } else {
                    _ = scanner.scanCharacter()
                }
            }
            return total > 0 ? total : nil
        }
        return nil
    }
}
