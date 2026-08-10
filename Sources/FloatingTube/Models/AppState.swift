import Foundation
import SwiftUI
import Combine
import AppKit

@MainActor
public class AppState: ObservableObject {
    public static let shared = AppState()
    
    @Published public var currentTarget: YouTubeTarget?
    @Published public var videoTitle: String = ""
    @Published public var inputUrl: String = ""
    
    // Window settings
    @Published public var isAlwaysOnTop: Bool = true {
        didSet {
            WindowManager.shared.setAlwaysOnTop(isAlwaysOnTop)
            UserDefaults.standard.set(isAlwaysOnTop, forKey: "FloatingTube_AlwaysOnTop")
        }
    }
    
    @Published public var isAspectRatioLocked: Bool = true {
        didSet {
            WindowManager.shared.setAspectRatioLocked(isAspectRatioLocked)
            UserDefaults.standard.set(isAspectRatioLocked, forKey: "FloatingTube_AspectRatioLocked")
        }
    }
    
    @Published public var opacity: Double = 1.0 {
        didSet {
            WindowManager.shared.setOpacity(opacity)
            UserDefaults.standard.set(opacity, forKey: "FloatingTube_Opacity")
        }
    }
    
    @Published public var isClickThrough: Bool = false {
        didSet {
            WindowManager.shared.setClickThrough(isClickThrough)
            webViewCommandPublisher.send("setClickThroughMode(\(isClickThrough));")
        }
    }
    
    // UI state
    @Published public var isHovered: Bool = false
    @Published public var isControlsPinned: Bool = false
    @Published public var isCleanMode: Bool = true {
        didSet {
            UserDefaults.standard.set(isCleanMode, forKey: "FloatingTube_CleanMode")
            showStatus(isCleanMode ? L10n.statusCleanMode : L10n.statusWebMode)
        }
    }
    @Published public var showHistorySheet: Bool = false
    @Published public var showShortcutsSheet: Bool = false
    @Published public var showQuickPresets: Bool = false
    @Published public var isLoading: Bool = false
    @Published public var statusMessage: String? = nil
    
    // Player feedback
    @Published public var isPlaying: Bool = true
    @Published public var isMuted: Bool = false
    @Published public var volume: Double = 100.0
    
    // History & Bookmarks
    @Published public var history: [PlayHistoryItem] = []
    @Published public var bookmarks: [PlayHistoryItem] = []
    
    // Command publisher for WKWebView bridge
    public let webViewCommandPublisher = PassthroughSubject<String, Never>()
    
    private var statusDismissWorkItem: DispatchWorkItem?
    
    public init() {
        self.isAlwaysOnTop = UserDefaults.standard.object(forKey: "FloatingTube_AlwaysOnTop") as? Bool ?? true
        self.isAspectRatioLocked = UserDefaults.standard.object(forKey: "FloatingTube_AspectRatioLocked") as? Bool ?? true
        self.opacity = UserDefaults.standard.object(forKey: "FloatingTube_Opacity") as? Double ?? 1.0
        self.isCleanMode = UserDefaults.standard.object(forKey: "FloatingTube_CleanMode") as? Bool ?? true
        
        // User requested target (TUVREvz3ejc)
        let defaultTarget = YouTubeTarget.video(id: "TUVREvz3ejc", startTime: nil, playlistId: "RDTUVREvz3ejc")
        self.currentTarget = defaultTarget
        self.videoTitle = "YouTube Video [TUVREvz3ejc]"
        
        loadSavedData()
        
        if let last = history.first {
            self.currentTarget = last.target
            self.videoTitle = last.title
        } else {
            self.addToHistory(target: defaultTarget, title: "YouTube Video [TUVREvz3ejc]")
        }
    }
    
    public func load(input: String) {
        let trimmed = input.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }
        
        if let target = YouTubeURLParser.parse(trimmed) {
            loadTarget(target)
            self.inputUrl = ""
        } else {
            showStatus(L10n.statusInvalidUrl)
        }
    }
    
    public func loadTarget(_ target: YouTubeTarget, title: String? = nil) {
        self.currentTarget = target
        let resolvedTitle = title ?? defaultTitle(for: target)
        self.videoTitle = resolvedTitle
        addToHistory(target: target, title: resolvedTitle)
        showStatus(L10n.statusLoadingVideo)
    }
    
    public func pasteAndPlayFromClipboard() {
        guard let clipboardString = NSPasteboard.general.string(forType: .string) else {
            showStatus(L10n.statusNoClipboardText)
            return
        }
        
        if let target = YouTubeURLParser.parse(clipboardString) {
            loadTarget(target)
            showStatus(L10n.statusPlayingClipboard)
        } else {
            showStatus(L10n.statusNoClipboardUrl)
        }
    }
    
    public func togglePlayPause() {
        isPlaying.toggle()
        let command = isPlaying ? "player.playVideo();" : "player.pauseVideo();"
        webViewCommandPublisher.send(command)
        showStatus(isPlaying ? L10n.play : L10n.pause)
    }
    
    public func toggleMute() {
        isMuted.toggle()
        let command = isMuted ? "player.mute();" : "player.unMute();"
        webViewCommandPublisher.send(command)
        showStatus(isMuted ? L10n.mute : L10n.unmute)
    }
    
    public func reloadVideo() {
        webViewCommandPublisher.send("location.reload();")
        showStatus(L10n.reloadVideo)
    }
    
    public func toggleAlwaysOnTop() {
        isAlwaysOnTop.toggle()
        showStatus(isAlwaysOnTop ? L10n.statusAlwaysOnTopEnabled : L10n.statusAlwaysOnTopDisabled)
    }
    
    public func toggleCleanMode() {
        isCleanMode.toggle()
        webViewCommandPublisher.send("toggleCleanMode(\(isCleanMode));")
    }
    
    public func openLogin() {
        self.isCleanMode = false
        if let url = URL(string: "https://accounts.google.com/ServiceLogin?service=youtube&continue=https://www.youtube.com") {
            loadTarget(.direct(url: url), title: L10n.googleLogin)
            showStatus(L10n.statusLoginRedirect)
        }
    }
    
    public func toggleAspectRatioLock() {
        isAspectRatioLocked.toggle()
        showStatus(isAspectRatioLocked ? L10n.statusAspectRatioLocked : L10n.statusAspectRatioFree)
    }
    
    public func toggleClickThrough() {
        isClickThrough.toggle()
        if isClickThrough {
            showStatus(L10n.statusClickThroughOn)
        } else {
            showStatus(L10n.statusClickThroughOff)
        }
    }
    
    public func setPresetSize(width: CGFloat, height: CGFloat, label: String) {
        WindowManager.shared.setSizePreset(width: width, height: height)
        showStatus("\(label)")
    }
    
    public func isCurrentTargetBookmarked() -> Bool {
        guard let current = currentTarget else { return false }
        return bookmarks.contains { $0.target == current }
    }
    
    public func toggleBookmark() {
        guard let current = currentTarget else { return }
        if let index = bookmarks.firstIndex(where: { $0.target == current }) {
            bookmarks.remove(at: index)
            showStatus(L10n.statusBookmarkRemoved)
        } else {
            let item = PlayHistoryItem(
                id: current.watchURLString,
                title: videoTitle.isEmpty ? "YouTube Video" : videoTitle,
                target: current,
                timestamp: Date(),
                isFavorite: true
            )
            bookmarks.insert(item, at: 0)
            showStatus(L10n.statusBookmarkAdded)
        }
        saveBookmarks()
    }
    
    public func addToHistory(target: YouTubeTarget, title: String) {
        history.removeAll { $0.target == target }
        let item = PlayHistoryItem(id: target.watchURLString, title: title, target: target, timestamp: Date())
        history.insert(item, at: 0)
        if history.count > 50 {
            history = Array(history.prefix(50))
        }
        saveHistory()
    }
    
    public func clearHistory() {
        history.removeAll()
        saveHistory()
        showStatus(L10n.statusHistoryCleared)
    }
    
    public func showStatus(_ message: String) {
        self.statusMessage = message
        statusDismissWorkItem?.cancel()
        let workItem = DispatchWorkItem { [weak self] in
            self?.statusMessage = nil
        }
        statusDismissWorkItem = workItem
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5, execute: workItem)
    }
    
    private func defaultTitle(for target: YouTubeTarget) -> String {
        switch target {
        case .video(let id, _, _):
            return "YouTube [\(id)]"
        case .playlist(let id):
            return "Playlist [\(id)]"
        case .direct(let url):
            return url.lastPathComponent
        }
    }
    
    private func saveHistory() {
        if let encoded = try? JSONEncoder().encode(history) {
            UserDefaults.standard.set(encoded, forKey: "FloatingTube_History")
        }
    }
    
    private func saveBookmarks() {
        if let encoded = try? JSONEncoder().encode(bookmarks) {
            UserDefaults.standard.set(encoded, forKey: "FloatingTube_Bookmarks")
        }
    }
    
    private func loadSavedData() {
        if let data = UserDefaults.standard.data(forKey: "FloatingTube_History"),
           let decoded = try? JSONDecoder().decode([PlayHistoryItem].self, from: data) {
            self.history = decoded
        }
        if let data = UserDefaults.standard.data(forKey: "FloatingTube_Bookmarks"),
           let decoded = try? JSONDecoder().decode([PlayHistoryItem].self, from: data) {
            self.bookmarks = decoded
        }
    }
}
