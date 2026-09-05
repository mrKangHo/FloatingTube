import Testing
import Foundation
import CoreGraphics
import Combine
import FloatingTubeDomain
@testable import FloatingTubePresentation

// MARK: - Mock Implementations

@MainActor
final class MockWindowManager: WindowManagerProtocol {
    var currentSize: CGSize = CGSize(width: 640, height: 360)
    var isFillScreen: Bool = false
    
    var setAlwaysOnTopCalledWith: Bool?
    var setAspectRatioLockedCalledWith: Bool?
    var setOpacityCalledWith: Double?
    var setClickThroughCalledWith: Bool?
    var setSizePresetCalledWith: (width: CGFloat, height: CGFloat)?
    var toggleFillScreenCalled = false
    var exitFillScreenIfNeededCalled = false
    var centerWindowCalled = false
    var closeWindowCalled = false
    var minimizeWindowCalled = false
    var toggleZoomCalled = false
    
    func setAlwaysOnTop(_ enabled: Bool) { setAlwaysOnTopCalledWith = enabled }
    func setAspectRatioLocked(_ locked: Bool) { setAspectRatioLockedCalledWith = locked }
    func setOpacity(_ opacity: Double) { setOpacityCalledWith = opacity }
    func setClickThrough(_ enabled: Bool) { setClickThroughCalledWith = enabled }
    func setSizePreset(width: CGFloat, height: CGFloat) { setSizePresetCalledWith = (width, height) }
    func toggleFillScreen() { toggleFillScreenCalled = true }
    func exitFillScreenIfNeeded() { exitFillScreenIfNeededCalled = true }
    func centerWindow() { centerWindowCalled = true }
    func closeWindow() { closeWindowCalled = true }
    func minimizeWindow() { minimizeWindowCalled = true }
    func toggleZoom() { toggleZoomCalled = true }
}

final class MockPresentationHistoryRepo: HistoryRepositoryProtocol, @unchecked Sendable {
    var history: [PlayHistoryItem] = []
    var bookmarks: [PlayHistoryItem] = []
    
    func fetchHistory() -> [PlayHistoryItem] { history }
    func saveHistory(_ history: [PlayHistoryItem]) { self.history = history }
    func fetchBookmarks() -> [PlayHistoryItem] { bookmarks }
    func saveBookmarks(_ bookmarks: [PlayHistoryItem]) { self.bookmarks = bookmarks }
    func clearHistory() { history.removeAll() }
}

final class MockPresentationPreferencesRepo: PreferencesRepositoryProtocol, @unchecked Sendable {
    var preferences: WindowPreferences = WindowPreferences(
        isAlwaysOnTop: true,
        isAspectRatioLocked: true,
        opacity: 1.0,
        isCleanMode: true
    )
    
    func loadPreferences() -> WindowPreferences { preferences }
    func savePreferences(_ preferences: WindowPreferences) { self.preferences = preferences }
}

struct MockPresentationPasteboard: PasteboardServiceProtocol {
    var copiedString: String?
    func getCopiedString() -> String? { copiedString }
}

// MARK: - AppState Test Suite

@Suite("AppState Presentation Tests")
@MainActor
struct AppStateTests {
    
    private func makeSUT(
        clipboardString: String? = nil,
        initialPreferences: WindowPreferences? = nil
    ) -> (
        sut: AppState,
        historyRepo: MockPresentationHistoryRepo,
        prefRepo: MockPresentationPreferencesRepo,
        winMgr: MockWindowManager
    ) {
        let historyRepo = MockPresentationHistoryRepo()
        let prefRepo = MockPresentationPreferencesRepo()
        if let initial = initialPreferences {
            prefRepo.preferences = initial
        }
        let pasteboard = MockPresentationPasteboard(copiedString: clipboardString)
        let winMgr = MockWindowManager()
        
        let resolveUseCase = ResolveYouTubeTargetUseCase()
        let historyUseCase = ManageHistoryUseCase(historyRepository: historyRepo)
        let pasteUseCase = PasteAndResolveUseCase(pasteboardService: pasteboard, resolveTargetUseCase: resolveUseCase)
        let prefUseCase = ManagePreferencesUseCase(preferencesRepository: prefRepo)
        
        let sut = AppState(
            resolveTargetUseCase: resolveUseCase,
            manageHistoryUseCase: historyUseCase,
            pasteAndResolveUseCase: pasteUseCase,
            preferencesUseCase: prefUseCase,
            windowManager: winMgr
        )
        
        return (sut, historyRepo, prefRepo, winMgr)
    }
    
    @Test("AppState loads initial preferences and sets default target")
    func testInitialState() {
        let customPrefs = WindowPreferences(
            isAlwaysOnTop: false,
            isAspectRatioLocked: false,
            opacity: 0.85,
            isCleanMode: false
        )
        let (sut, _, _, _) = makeSUT(initialPreferences: customPrefs)
        
        #expect(sut.isAlwaysOnTop == false)
        #expect(sut.isAspectRatioLocked == false)
        #expect(sut.opacity == 0.85)
        #expect(sut.isCleanMode == false)
        #expect(sut.currentTarget != nil)
    }
    
    @Test("Loading valid YouTube URL updates currentTarget and resets inputUrl")
    func testLoadValidURL() {
        let (sut, _, _, _) = makeSUT()
        sut.inputUrl = "https://www.youtube.com/watch?v=dQw4w9WgXcQ"
        sut.load(input: sut.inputUrl)
        
        #expect(sut.currentTarget == .video(id: "dQw4w9WgXcQ", startTime: nil, playlistId: nil))
        #expect(sut.inputUrl == "")
        #expect(sut.history.count >= 1)
        #expect(sut.history.first?.target == .video(id: "dQw4w9WgXcQ"))
    }
    
    @Test("Loading invalid string shows status error message or ignores empty string")
    func testLoadInvalidURL() {
        let (sut, _, _, _) = makeSUT()
        
        // Empty input is ignored
        sut.statusMessage = nil
        sut.load(input: "   ")
        #expect(sut.statusMessage == nil)
        
        // Invalid URL shows invalid url status
        sut.load(input: "http:// invalid url with spaces")
        #expect(sut.statusMessage == L10n.statusInvalidUrl)
    }
    
    @Test("Paste and play from clipboard resolves target when clipboard has YouTube link")
    func testPasteAndPlayValid() {
        let (sut, _, _, _) = makeSUT(clipboardString: "https://youtu.be/3jz_k3kgDkE")
        sut.pasteAndPlayFromClipboard()
        
        #expect(sut.currentTarget == .video(id: "3jz_k3kgDkE"))
        #expect(sut.statusMessage != nil)
    }
    
    @Test("Paste and play with empty clipboard shows notice")
    func testPasteAndPlayEmpty() {
        let (sut, _, _, _) = makeSUT(clipboardString: nil)
        let previousTarget = sut.currentTarget
        sut.pasteAndPlayFromClipboard()
        
        #expect(sut.currentTarget == previousTarget)
        #expect(sut.statusMessage != nil)
    }
    
    @Test("Playback controls toggle isPlaying and isMuted with commands")
    func testPlaybackControls() {
        let (sut, _, _, _) = makeSUT()
        
        var commands: [String] = []
        let cancellable = sut.webViewCommandPublisher.sink { command in
            commands.append(command)
        }
        _ = cancellable
        
        // Initial state isPlaying is true
        sut.togglePlayPause()
        #expect(sut.isPlaying == false)
        #expect(commands.contains("player.pauseVideo();"))
        
        sut.togglePlayPause()
        #expect(sut.isPlaying == true)
        #expect(commands.contains("player.playVideo();"))
        
        // Mute
        sut.toggleMute()
        #expect(sut.isMuted == true)
        #expect(commands.contains("player.mute();"))
        
        sut.toggleMute()
        #expect(sut.isMuted == false)
        #expect(commands.contains("player.unMute();"))
    }
    
    @Test("Window property changes update windowManager and persist preferences")
    func testWindowPropertyChanges() {
        let (sut, _, prefRepo, winMgr) = makeSUT()
        
        sut.isAlwaysOnTop = false
        #expect(winMgr.setAlwaysOnTopCalledWith == false)
        #expect(prefRepo.preferences.isAlwaysOnTop == false)
        
        sut.isAspectRatioLocked = false
        #expect(winMgr.setAspectRatioLockedCalledWith == false)
        #expect(prefRepo.preferences.isAspectRatioLocked == false)
        
        sut.opacity = 0.5
        #expect(winMgr.setOpacityCalledWith == 0.5)
        #expect(prefRepo.preferences.opacity == 0.5)
        
        sut.isClickThrough = true
        #expect(winMgr.setClickThroughCalledWith == true)
    }
    
    @Test("Set preset size delegates to window manager")
    func testPresetSizes() {
        let (sut, _, _, winMgr) = makeSUT()
        sut.setPresetSize(width: 512, height: 288, label: "중형")
        
        #expect(winMgr.setSizePresetCalledWith?.width == 512)
        #expect(winMgr.setSizePresetCalledWith?.height == 288)
        #expect(sut.statusMessage == "중형")
    }
    
    @Test("Bookmarks can be added, queried, and toggled")
    func testBookmarks() {
        let (sut, _, _, _) = makeSUT()
        let target = YouTubeTarget.video(id: "bookmark_test_id")
        sut.loadTarget(target, title: "Bookmark Test Title")
        
        #expect(sut.isCurrentTargetBookmarked() == false)
        
        // Add bookmark
        sut.toggleBookmark()
        #expect(sut.isCurrentTargetBookmarked() == true)
        #expect(sut.bookmarks.count == 1)
        #expect(sut.bookmarks.first?.target == target)
        
        // Remove bookmark
        sut.toggleBookmark()
        #expect(sut.isCurrentTargetBookmarked() == false)
        #expect(sut.bookmarks.isEmpty)
    }
    
    @Test("Clear history resets history list and persists")
    func testClearHistory() {
        let (sut, historyRepo, _, _) = makeSUT()
        sut.loadTarget(.video(id: "vid_1"), title: "Video 1")
        sut.loadTarget(.video(id: "vid_2"), title: "Video 2")
        #expect(!sut.history.isEmpty)
        
        sut.clearHistory()
        #expect(sut.history.isEmpty)
        #expect(historyRepo.history.isEmpty)
    }
}
