import Testing
import Foundation
@testable import FloatingTube

@Test func testUserSpecificURL() throws {
    let url = "https://www.youtube.com/watch?v=TUVREvz3ejc&list=RDTUVREvz3ejc&start_radio=1"
    let target = YouTubeURLParser.parse(url)
    
    #expect(target == .video(id: "TUVREvz3ejc", startTime: nil, playlistId: "RDTUVREvz3ejc"))
    #expect(target?.watchURLString.contains("TUVREvz3ejc") == true)
}
