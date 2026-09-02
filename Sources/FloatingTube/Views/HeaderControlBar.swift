import SwiftUI
import AppKit

public struct HeaderControlBar: View {
    @ObservedObject var appState: AppState
    @ObservedObject var windowManager = WindowManager.shared
    @FocusState private var isSearchFocused: Bool
    
    public init(appState: AppState) {
        self.appState = appState
    }
    
    public var body: some View {
        HStack(spacing: 8) {
            // Interactive macOS Window Traffic Lights
            MacOSTrafficLights()
                .padding(.leading, 4)
            
            // Drag handle spacer
            WindowDragHandle()
                .frame(width: 12, height: 24)
            
            // URL / Search Input Field (Glass Pill)
            HStack(spacing: 5) {
                Image(systemName: "magnifyingglass")
                    .font(.system(size: 10, weight: .semibold))
                    .foregroundColor(isSearchFocused ? .blue : .white.opacity(0.5))
                
                TextField(L10n.searchPlaceholder, text: $appState.inputUrl)
                    .textFieldStyle(.plain)
                    .font(.system(size: 11, weight: .regular))
                    .foregroundColor(.white)
                    .focused($isSearchFocused)
                    .onSubmit {
                        appState.load(input: appState.inputUrl)
                    }
                
                if !appState.inputUrl.isEmpty {
                    Button(action: { appState.inputUrl = "" }) {
                        Image(systemName: "xmark.circle.fill")
                            .font(.system(size: 11))
                            .foregroundColor(.white.opacity(0.6))
                    }
                    .buttonStyle(.plain)
                }
                
                // Quick Paste button with shortcut hint
                Button(action: {
                    appState.pasteAndPlayFromClipboard()
                }) {
                    Image(systemName: "doc.on.clipboard")
                        .font(.system(size: 10, weight: .semibold))
                        .foregroundColor(.white.opacity(0.85))
                }
                .buttonStyle(.plain)
                .help(L10n.playClipboardTooltip)
            }
            .padding(.horizontal, 9)
            .padding(.vertical, 4.5)
            .background(
                RoundedRectangle(cornerRadius: 8, style: .continuous)
                    .fill(Color.black.opacity(isSearchFocused ? 0.6 : 0.4))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 8, style: .continuous)
                    .stroke(
                        isSearchFocused ? Color.blue.opacity(0.7) : Color.white.opacity(0.12),
                        lineWidth: isSearchFocused ? 1.2 : 0.8
                    )
            )
            .animation(.easeInOut(duration: 0.15), value: isSearchFocused)
            
            // Essential Quick Action Buttons
            HStack(spacing: 4) {
                // Bookmark Toggle
                TubeIconButton(
                    icon: appState.isCurrentTargetBookmarked() ? "star.fill" : "star",
                    isActive: appState.isCurrentTargetBookmarked(),
                    activeColor: .yellow
                ) {
                    appState.toggleBookmark()
                }
                .help(L10n.addBookmark)
                
                // History & Bookmarks Sheet Launcher
                TubeIconButton(
                    icon: "clock.arrow.circlepath",
                    isActive: appState.showHistorySheet,
                    activeColor: .purple
                ) {
                    withAnimation(.spring(response: 0.28, dampingFraction: 0.8)) {
                        appState.showHistorySheet.toggle()
                        appState.showShortcutsSheet = false
                    }
                }
                .help(L10n.historySheet)
                
                // Shortcuts Guide Sheet Launcher
                TubeIconButton(
                    icon: "command",
                    isActive: appState.showShortcutsSheet,
                    activeColor: .cyan
                ) {
                    withAnimation(.spring(response: 0.28, dampingFraction: 0.8)) {
                        appState.showShortcutsSheet.toggle()
                        appState.showHistorySheet = false
                    }
                }
                .help(L10n.shortcutsSheet)
                
                // Always on Top Toggle
                TubeIconButton(
                    icon: appState.isAlwaysOnTop ? "pin.fill" : "pin",
                    isActive: appState.isAlwaysOnTop,
                    activeColor: .orange
                ) {
                    appState.toggleAlwaysOnTop()
                }
                .help(L10n.alwaysOnTopTooltip)
                
                // View Mode Toggle (Clean Video ↔ Full Web)
                TubeIconButton(
                    icon: appState.isCleanMode ? "play.rectangle.fill" : "globe",
                    isActive: appState.isCleanMode,
                    activeColor: .green
                ) {
                    appState.toggleCleanMode()
                }
                .help(appState.isCleanMode ? L10n.currentCleanModeHelp : L10n.currentWebModeHelp)
            }
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 7)
        .background(
            ZStack {
                VisualEffectBlur(material: .hudWindow, blendingMode: .withinWindow)
                Color.black.opacity(0.35)
            }
        )
        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .stroke(
                    LinearGradient(
                        colors: [Color.white.opacity(0.22), Color.white.opacity(0.08)],
                        startPoint: .top,
                        endPoint: .bottom
                    ),
                    lineWidth: 0.9
                )
        )
        .shadow(color: .black.opacity(0.35), radius: 10, x: 0, y: 4)
        .padding(.horizontal, 8)
        .padding(.top, 6)
    }
}
