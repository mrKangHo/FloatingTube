import SwiftUI

public struct ShortcutsSheetView: View {
    @ObservedObject var appState: AppState
    
    public init(appState: AppState) {
        self.appState = appState
    }
    
    public var body: some View {
        VStack(spacing: 0) {
            // Header
            HStack {
                HStack(spacing: 6) {
                    Image(systemName: "command")
                        .font(.system(size: 13, weight: .bold))
                    Text(L10n.shortcutsTitle)
                        .font(.system(size: 13, weight: .bold))
                }
                Spacer()
                Button(action: {
                    appState.showShortcutsSheet = false
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .font(.system(size: 14))
                        .foregroundColor(.white.opacity(0.6))
                }
                .buttonStyle(.plain)
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 10)
            .background(Color.black.opacity(0.5))
            
            Divider()
                .background(Color.white.opacity(0.1))
            
            // Shortcut list
            ScrollView {
                VStack(spacing: 6) {
                    shortcutRow(keys: ["⌘", "V"], description: L10n.playClipboardLink)
                    shortcutRow(keys: ["⌘", "T"], description: L10n.alwaysOnTop)
                    shortcutRow(keys: ["⌘", "⇧", "C"], description: L10n.clickThroughMode)
                    shortcutRow(keys: ["F"], description: L10n.toggleFullscreen)
                    shortcutRow(keys: ["Space"], description: "\(L10n.play) / \(L10n.pause)")
                    shortcutRow(keys: ["M"], description: "\(L10n.mute) / \(L10n.unmute)")
                    shortcutRow(keys: ["⌘", "R"], description: L10n.reloadVideo)
                    shortcutRow(keys: ["⌘", "Q"], description: L10n.quitApp)
                }
                .padding(12)
            }
        }
        .frame(width: 360, height: 260)
        .background(
            VisualEffectBlur(material: .hudWindow, blendingMode: .withinWindow)
                .overlay(Color.black.opacity(0.55))
        )
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.white.opacity(0.15), lineWidth: 1)
        )
        .shadow(radius: 20)
    }
    
    private func shortcutRow(keys: [String], description: String) -> some View {
        HStack {
            Text(description)
                .font(.system(size: 11, weight: .regular))
                .foregroundColor(.white.opacity(0.85))
            Spacer()
            HStack(spacing: 3) {
                ForEach(keys, id: \.self) { key in
                    Text(key)
                        .font(.system(size: 10, weight: .semibold, design: .monospaced))
                        .foregroundColor(.white)
                        .padding(.horizontal, 5)
                        .padding(.vertical, 2)
                        .background(
                            RoundedRectangle(cornerRadius: 4)
                                .fill(Color.white.opacity(0.15))
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 4)
                                .stroke(Color.white.opacity(0.2), lineWidth: 0.5)
                        )
                }
            }
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
        .background(
            RoundedRectangle(cornerRadius: 6)
                .fill(Color.white.opacity(0.04))
        )
    }
}
