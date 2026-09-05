import Foundation
import SwiftUI
import Combine
import AppKit
import FloatingTubeDomain

@MainActor
public class AppState: ObservableObject {
    public static var shared: AppState!
    
    // Injected UseCases & Services
    private let resolveTargetUseCase: ResolveYouTubeTargetUseCase
    private let manageHistoryUseCase: ManageHistoryUseCase
    private let pasteAndResolveUseCase: PasteAndResolveUseCase
    private let preferencesUseCase: ManagePreferencesUseCase
    public let windowManager: WindowManagerProtocol
    
    @Published public var currentTarget: YouTubeTarget?
    @Published public var videoTitle: String = ""
    @Published public var inputUrl: String = ""
    
    // Window settings
    @Published public var isAlwaysOnTop: Bool = true {
        didSet {
            windowManager.setAlwaysOnTop(isAlwaysOnTop)
            persistPreferences()
        }
    }
    
    @Published public var isAspectRatioLocked: Bool = true {
        didSet {
            windowManager.setAspectRatioLocked(isAspectRatioLocked)
            persistPreferences()
        }
    }
    
    @Published public var opacity: Double = 1.0 {
        didSet {
            windowManager.setOpacity(opacity)
            persistPreferences()
        }
    }
    
    @Published public var isClickThrough: Bool = false {
        didSet {
            windowManager.setClickThrough(isClickThrough)
            webViewCommandPublisher.send("setClickThroughMode(\(isClickThrough));")
        }
    }
    
    // UI state
    @Published public var isHovered: Bool = false
    @Published public var isControlsPinned: Bool = false
    @Published public var isCleanMode: Bool = true {
        didSet {
            persistPreferences()
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
    
    public init(
        resolveTargetUseCase: ResolveYouTubeTargetUseCase = ResolveYouTubeTargetUseCase(),
        manageHistoryUseCase: ManageHistoryUseCase,
        pasteAndResolveUseCase: PasteAndResolveUseCase,
        preferencesUseCase: ManagePreferencesUseCase,
        windowManager: WindowManagerProtocol
    ) {
        self.resolveTargetUseCase = resolveTargetUseCase
        self.manageHistoryUseCase = manageHistoryUseCase
        self.pasteAndResolveUseCase = pasteAndResolveUseCase
        self.preferencesUseCase = preferencesUseCase
        self.windowManager = windowManager
        
        let prefs = preferencesUseCase.loadPreferences()
        self._isAlwaysOnTop = Published(initialValue: prefs.isAlwaysOnTop)
        self._isAspectRatioLocked = Published(initialValue: prefs.isAspectRatioLocked)
        self._opacity = Published(initialValue: prefs.opacity)
        self._isCleanMode = Published(initialValue: prefs.isCleanMode)
        
        windowManager.setAlwaysOnTop(prefs.isAlwaysOnTop)
        windowManager.setAspectRatioLocked(prefs.isAspectRatioLocked)
        windowManager.setOpacity(prefs.opacity)
        
        // Initial history & bookmarks from use case
        self.history = manageHistoryUseCase.loadHistory()
        self.bookmarks = manageHistoryUseCase.loadBookmarks()
        
        // Default target (TUVREvz3ejc)
        let defaultTarget = YouTubeTarget.video(id: "TUVREvz3ejc", startTime: nil, playlistId: "RDTUVREvz3ejc")
        self.currentTarget = defaultTarget
        self.videoTitle = "YouTube Video [TUVREvz3ejc]"
        
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
        
        if let target = resolveTargetUseCase.execute(trimmed) {
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
        let result = pasteAndResolveUseCase.execute()
        guard let raw = result.rawString, !raw.isEmpty else {
            showStatus(L10n.statusNoClipboardText)
            return
        }
        
        if let target = result.target {
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
    
    public func setCleanMode(_ enabled: Bool) {
        guard isCleanMode != enabled else { return }
        isCleanMode = enabled
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
        windowManager.setSizePreset(width: width, height: height)
        showStatus("\(label)")
    }
    
    public func bringToFront() {
        windowManager.bringToFront()
    }
    
    public func closeWindow() {
        windowManager.closeWindow()
    }
    
    public func minimizeWindow() {
        windowManager.minimizeWindow()
    }
    
    public func toggleZoom() {
        windowManager.toggleZoom()
    }
    
    public func openInExternalBrowser() {
        guard let target = currentTarget, let url = URL(string: target.watchURLString) else { return }
        NSWorkspace.shared.open(url)
    }
    
    public func isCurrentTargetBookmarked() -> Bool {
        guard let current = currentTarget else { return false }
        return bookmarks.contains { $0.target == current }
    }
    
    public func toggleBookmark() {
        guard let current = currentTarget else { return }
        let (isBookmarked, updatedBookmarks) = manageHistoryUseCase.toggleBookmark(
            target: current,
            title: videoTitle.isEmpty ? "YouTube Video" : videoTitle,
            currentBookmarks: bookmarks
        )
        self.bookmarks = updatedBookmarks
        showStatus(isBookmarked ? L10n.statusBookmarkAdded : L10n.statusBookmarkRemoved)
    }
    
    public func addToHistory(target: YouTubeTarget, title: String) {
        self.history = manageHistoryUseCase.addToHistory(
            target: target,
            title: title,
            currentHistory: history
        )
    }
    
    public func clearHistory() {
        manageHistoryUseCase.clearHistory()
        self.history.removeAll()
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
    
    private func persistPreferences() {
        let prefs = WindowPreferences(
            isAlwaysOnTop: isAlwaysOnTop,
            isAspectRatioLocked: isAspectRatioLocked,
            opacity: opacity,
            isCleanMode: isCleanMode
        )
        preferencesUseCase.savePreferences(prefs)
    }
}
