import SwiftUI

@MainActor
public struct ShortcutsSheetView: View {
    @ObservedObject var appState: AppState
    
    public init(appState: AppState) {
        self.appState = appState
    }
    
    public var body: some View {
        VStack(spacing: 0) {
            // Header Bar
            HStack {
                HStack(spacing: 7) {
                    Image(systemName: "command")
                        .font(.system(size: 13, weight: .bold))
                        .foregroundColor(.cyan)
                    Text(L10n.shortcutsTitle)
                        .font(.system(size: 13, weight: .bold))
                        .foregroundColor(.white)
                }
                Spacer()
                Button(action: {
                    withAnimation(.spring(response: 0.25, dampingFraction: 0.8)) {
                        appState.showShortcutsSheet = false
                    }
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .font(.system(size: 15))
                        .foregroundColor(.white.opacity(0.6))
                }
                .buttonStyle(.plain)
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 12)
            .background(Color.black.opacity(0.4))
            
            Divider()
                .background(Color.white.opacity(0.12))
            
            // Shortcut List
            ScrollView {
                VStack(spacing: 5) {
                    shortcutRow(keys: ["⌘", "V"], description: L10n.playClipboardLink)
                    shortcutRow(keys: ["⌘", "T"], description: L10n.alwaysOnTop)
                    shortcutRow(keys: ["⌘", "⇧", "C"], description: L10n.clickThroughMode)
                    shortcutRow(keys: ["F"], description: L10n.toggleFullscreen)
                    shortcutRow(keys: ["Space"], description: "\(L10n.play) / \(L10n.pause)")
                    shortcutRow(keys: ["M"], description: "\(L10n.mute) / \(L10n.unmute)")
                    shortcutRow(keys: ["⌘", "R"], description: L10n.reloadVideo)
                    shortcutRow(keys: ["⌘", "1~4"], description: L10n.windowPresetShortcutDesc)
                    shortcutRow(keys: ["⌘", "Q"], description: L10n.quitApp)
                }
                .padding(12)
            }
        }
        .frame(width: 370, height: 280)
        .background(
            ZStack {
                VisualEffectBlur(material: .popover, blendingMode: .withinWindow)
                Color.black.opacity(0.6)
            }
        )
        .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .stroke(
                    LinearGradient(
                        colors: [Color.white.opacity(0.25), Color.white.opacity(0.08)],
                        startPoint: .top,
                        endPoint: .bottom
                    ),
                    lineWidth: 1
                )
        )
        .shadow(color: .black.opacity(0.5), radius: 24, x: 0, y: 8)
    }
    
    private func shortcutRow(keys: [String], description: String) -> some View {
        HStack {
            Text(description)
                .font(.system(size: 11, weight: .medium))
                .foregroundColor(.white.opacity(0.9))
            Spacer()
            HStack(spacing: 4) {
                ForEach(keys, id: \.self) { key in
                    KeyCapView(key: key)
                }
            }
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 5)
        .background(
            RoundedRectangle(cornerRadius: 7, style: .continuous)
                .fill(Color.white.opacity(0.05))
        )
    }
}
