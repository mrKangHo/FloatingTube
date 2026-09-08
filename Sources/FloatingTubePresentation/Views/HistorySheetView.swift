import SwiftUI
import FloatingTubeDomain

@MainActor
public struct HistorySheetView: View {
    @ObservedObject var appState: AppState
    @State private var selectedTab = 0 // 0: Bookmarks, 1: History
    
    public init(appState: AppState) {
        self.appState = appState
    }
    
    public var body: some View {
        VStack(spacing: 0) {
            // Header Bar
            HStack(spacing: 10) {
                Picker("", selection: $selectedTab) {
                    Text("\(L10n.bookmarksTab) (\(appState.bookmarks.count))").tag(0)
                    Text("\(L10n.recentHistory) (\(appState.history.count))").tag(1)
                }
                .pickerStyle(.segmented)
                .frame(width: 250)
                
                Spacer()
                
                if selectedTab == 1 && !appState.history.isEmpty {
                    Button(action: {
                        withAnimation {
                            appState.clearHistory()
                        }
                    }) {
                        HStack(spacing: 3) {
                            Image(systemName: "trash")
                                .font(.system(size: 10))
                            Text(L10n.clearHistoryButton)
                                .font(.system(size: 10, weight: .medium))
                        }
                        .foregroundColor(.red.opacity(0.85))
                        .padding(.horizontal, 6)
                        .padding(.vertical, 3)
                        .background(Color.red.opacity(0.12))
                        .cornerRadius(5)
                    }
                    .buttonStyle(.plain)
                }
                
                Button(action: {
                    withAnimation(.spring(response: 0.25, dampingFraction: 0.8)) {
                        appState.showHistorySheet = false
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
            
            // Content List
            let items = selectedTab == 0 ? appState.bookmarks : appState.history
            
            if items.isEmpty {
                VStack(spacing: 10) {
                    Spacer()
                    Image(systemName: selectedTab == 0 ? "star.slash.fill" : "clock.badge.exclamationmark")
                        .font(.system(size: 32, weight: .light))
                        .foregroundColor(.white.opacity(0.35))
                    Text(selectedTab == 0 ? L10n.noBookmarksYet : L10n.noHistoryYet)
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(.white.opacity(0.6))
                        .multilineTextAlignment(.center)
                    Spacer()
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                ScrollView {
                    LazyVStack(spacing: 5) {
                        ForEach(items) { item in
                            ItemRowView(item: item, isCurrent: item.target == appState.currentTarget) {
                                appState.loadTarget(item.target, title: item.title)
                                withAnimation {
                                    appState.showHistorySheet = false
                                }
                            }
                        }
                    }
                    .padding(10)
                }
            }
        }
        .frame(width: 390, height: 270)
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
}

struct ItemRowView: View {
    let item: PlayHistoryItem
    let isCurrent: Bool
    let onSelect: () -> Void
    
    @State private var isHovered = false
    
    var body: some View {
        Button(action: onSelect) {
            HStack(spacing: 10) {
                ZStack {
                    RoundedRectangle(cornerRadius: 6, style: .continuous)
                        .fill(isCurrent ? Color.red.opacity(0.25) : Color.white.opacity(0.08))
                        .frame(width: 28, height: 28)
                    
                    Image(systemName: isCurrent ? "play.fill" : "play.rectangle")
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundColor(isCurrent ? .red : .white.opacity(0.75))
                }
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(item.title)
                        .font(.system(size: 11, weight: isCurrent ? .bold : .medium))
                        .foregroundColor(isCurrent ? .white : .white.opacity(0.9))
                        .lineLimit(1)
                    
                    Text(formattedDate(item.timestamp))
                        .font(.system(size: 9, weight: .regular))
                        .foregroundColor(.white.opacity(0.45))
                }
                
                Spacer()
                
                if isCurrent {
                    Text(L10n.play)
                        .font(.system(size: 9, weight: .bold))
                        .foregroundColor(.red)
                        .padding(.horizontal, 6)
                        .padding(.vertical, 2.5)
                        .background(
                            Capsule()
                                .fill(Color.red.opacity(0.2))
                        )
                        .overlay(
                            Capsule()
                                .stroke(Color.red.opacity(0.5), lineWidth: 0.6)
                        )
                }
            }
            .padding(.horizontal, 10)
            .padding(.vertical, 7)
            .background(
                RoundedRectangle(cornerRadius: 8, style: .continuous)
                    .fill(isHovered ? Color.white.opacity(0.12) : (isCurrent ? Color.white.opacity(0.06) : Color.clear))
            )
            .scaleEffect(isHovered ? 1.01 : 1.0)
        }
        .buttonStyle(.plain)
        .onHover { hovering in
            withAnimation(.easeInOut(duration: 0.12)) {
                isHovered = hovering
            }
        }
    }
    
    private func formattedDate(_ date: Date) -> String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .short
        return formatter.localizedString(for: date, relativeTo: Date())
    }
}
