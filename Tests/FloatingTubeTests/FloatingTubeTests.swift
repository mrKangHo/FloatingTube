import Testing
import Foundation
@testable import FloatingTube

@Test func testParseStandardYouTubeURL() throws {
    let url = "https://www.youtube.com/watch?v=jfKfPfyJRdk"
    let target = YouTubeURLParser.parse(url)
    
    #expect(target == .video(id: "jfKfPfyJRdk", startTime: nil, playlistId: nil))
}

@Test func testParseShortURL() throws {
    let url = "https://youtu.be/jfKfPfyJRdk?t=120"
    let target = YouTubeURLParser.parse(url)
    
    #expect(target == .video(id: "jfKfPfyJRdk", startTime: 120, playlistId: nil))
}

@Test func testParseShortsURL() throws {
    let url = "https://www.youtube.com/shorts/3jz_k3kgDkE"
    let target = YouTubeURLParser.parse(url)
    
    #expect(target == .video(id: "3jz_k3kgDkE", startTime: nil, playlistId: nil))
}

@Test func testParseLiveURL() throws {
    let url = "https://www.youtube.com/live/jfKfPfyJRdk"
    let target = YouTubeURLParser.parse(url)
    
    #expect(target == .video(id: "jfKfPfyJRdk", startTime: nil, playlistId: nil))
}

@Test func testParseRawVideoID() throws {
    let rawId = "jfKfPfyJRdk"
    let target = YouTubeURLParser.parse(rawId)
    
    #expect(target == .video(id: "jfKfPfyJRdk", startTime: nil, playlistId: nil))
}

@Test func testEmbedURLGeneration() throws {
    let target = YouTubeTarget.video(id: "jfKfPfyJRdk", startTime: 30, playlistId: nil)
    let embedURL = target.embedURL?.absoluteString
    
    #expect(embedURL != nil)
    #expect(embedURL?.contains("jfKfPfyJRdk") == true)
    #expect(embedURL?.contains("start=30") == true)
    #expect(embedURL?.contains("autoplay=1") == true)
}
