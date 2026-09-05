import Testing
import Foundation
import FloatingTubeDomain
import FloatingTubeData

@Suite("UserDefaults Repositories Tests")
struct UserDefaultsRepositoryTests {
    private func makeCleanUserDefaults() -> UserDefaults {
        let suiteName = "test.floatingtube.\(UUID().uuidString)"
        let defaults = UserDefaults(suiteName: suiteName)!
        defaults.removePersistentDomain(forName: suiteName)
        return defaults
    }
    
    @Test("UserDefaultsHistoryRepository saves and fetches history & bookmarks")
    func testHistoryRepository() {
        let defaults = makeCleanUserDefaults()
        let repo = UserDefaultsHistoryRepository(
            userDefaults: defaults,
            historyKey: "test_history",
            bookmarksKey: "test_bookmarks"
        )
        
        #expect(repo.fetchHistory().isEmpty)
        #expect(repo.fetchBookmarks().isEmpty)
        
        let item1 = PlayHistoryItem(id: "id_1", title: "Video 1", target: .video(id: "id_1"))
        let item2 = PlayHistoryItem(id: "id_2", title: "Video 2", target: .video(id: "id_2"), isFavorite: true)
        
        repo.saveHistory([item1])
        repo.saveBookmarks([item2])
        
        let fetchedHistory = repo.fetchHistory()
        let fetchedBookmarks = repo.fetchBookmarks()
        
        #expect(fetchedHistory.count == 1)
        #expect(fetchedHistory.first?.id == "id_1")
        #expect(fetchedBookmarks.count == 1)
        #expect(fetchedBookmarks.first?.id == "id_2")
        
        repo.clearHistory()
        #expect(repo.fetchHistory().isEmpty)
        #expect(repo.fetchBookmarks().count == 1) // Bookmarks remain intact
    }
    
    @Test("UserDefaultsPreferencesRepository saves and loads preferences")
    func testPreferencesRepository() {
        let defaults = makeCleanUserDefaults()
        let repo = UserDefaultsPreferencesRepository(userDefaults: defaults)
        
        let initial = repo.loadPreferences()
        #expect(initial.isAlwaysOnTop == true)
        #expect(initial.isAspectRatioLocked == true)
        #expect(initial.opacity == 1.0)
        
        let custom = WindowPreferences(
            isAlwaysOnTop: false,
            isAspectRatioLocked: false,
            opacity: 0.7,
            isCleanMode: false
        )
        repo.savePreferences(custom)
        
        let loaded = repo.loadPreferences()
        #expect(loaded == custom)
    }
}
