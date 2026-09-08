import Testing
import Foundation
import FloatingTubeDomain

@Suite("ResolveYouTubeTargetUseCase Tests")
struct ResolveYouTubeTargetUseCaseTests {
    let useCase = ResolveYouTubeTargetUseCase()
    
    @Test("Parse standard YouTube watch URL")
    func testParseStandardYouTubeURL() {
        let url = "https://www.youtube.com/watch?v=jfKfPfyJRdk"
        let target = useCase.execute(url)
        
        #expect(target == .video(id: "jfKfPfyJRdk", startTime: nil, playlistId: nil))
    }
    
    @Test("Parse youtu.be short URL with timestamp")
    func testParseShortURL() {
        let url = "https://youtu.be/jfKfPfyJRdk?t=120"
        let target = useCase.execute(url)
        
        #expect(target == .video(id: "jfKfPfyJRdk", startTime: 120, playlistId: nil))
    }
    
    @Test("Parse YouTube shorts URL")
    func testParseShortsURL() {
        let url = "https://www.youtube.com/shorts/3jz_k3kgDkE"
        let target = useCase.execute(url)
        
        #expect(target == .video(id: "3jz_k3kgDkE", startTime: nil, playlistId: nil))
    }
    
    @Test("Parse YouTube live URL")
    func testParseLiveURL() {
        let url = "https://www.youtube.com/live/jfKfPfyJRdk"
        let target = useCase.execute(url)
        
        #expect(target == .video(id: "jfKfPfyJRdk", startTime: nil, playlistId: nil))
    }
    
    @Test("Parse raw 11-char video ID")
    func testParseRawVideoID() {
        let rawId = "jfKfPfyJRdk"
        let target = useCase.execute(rawId)
        
        #expect(target == .video(id: "jfKfPfyJRdk", startTime: nil, playlistId: nil))
    }
    
    @Test("Embed URL generation")
    func testEmbedURLGeneration() {
        let target = YouTubeTarget.video(id: "jfKfPfyJRdk", startTime: 30, playlistId: nil)
        let embedURL = target.embedURL?.absoluteString
        
        #expect(embedURL != nil)
        #expect(embedURL?.contains("jfKfPfyJRdk") == true)
        #expect(embedURL?.contains("start=30") == true)
        #expect(embedURL?.contains("autoplay=1") == true)
    }
    
    @Test("Parse user specific URL with list and radio params")
    func testUserSpecificURL() {
        let url = "https://www.youtube.com/watch?v=TUVREvz3ejc&list=RDTUVREvz3ejc&start_radio=1"
        let target = useCase.execute(url)
        
        #expect(target == .video(id: "TUVREvz3ejc", startTime: nil, playlistId: "RDTUVREvz3ejc"))
        #expect(target?.watchURLString.contains("TUVREvz3ejc") == true)
    }
    
    @Test("Parse non-YouTube direct web link")
    func testParseDirectURL() {
        let url = "https://apple.com"
        let target = useCase.execute(url)
        
        #expect(target == .direct(url: URL(string: "https://apple.com")!))
    }
    
    @Test("Empty input returns nil")
    func testEmptyInput() {
        #expect(useCase.execute("") == nil)
        #expect(useCase.execute("   \n") == nil)
    }
}
