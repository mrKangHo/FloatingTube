import SwiftUI

public struct HistorySheetView: View {
    @ObservedObject var appState: AppState
    @State private var selectedTab = 0 // 0: Bookmarks, 1: History
    
    public init(appState: AppState) {
        self.appState = appState
    }
    
    public var body: some View {
        VStack(spacing: 0) {
            // Header
            HStack {
                Picker("", selection: $selectedTab) {
                    Text("⭐ 즐겨찾기 (\(appState.bookmarks.count))").tag(0)
                    Text("🕒 최근 재생 (\(appState.history.count))").tag(1)
                }
                .pickerStyle(.segmented)
                .frame(width: 240)
                
                Spacer()
                
                if selectedTab == 1 && !appState.history.isEmpty {
                    Button(action: {
                        appState.clearHistory()
                    }) {
                        Text("기록 지우기")
                            .font(.system(size: 10))
                            .foregroundColor(.red.opacity(0.8))
                    }
                    .buttonStyle(.plain)
                }
                
                Button(action: {
                    appState.showHistorySheet = false
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
            
            // Content List
            let items = selectedTab == 0 ? appState.bookmarks : appState.history
            
            if items.isEmpty {
                VStack(spacing: 8) {
                    Spacer()
                    Image(systemName: selectedTab == 0 ? "star.slash" : "clock.arrow.circlepath")
                        .font(.system(size: 28))
                        .foregroundColor(.white.opacity(0.3))
                    Text(selectedTab == 0 ? "저장된 즐겨찾기가 없습니다.\n상단의 ⭐ 버튼을 눌러 추가해보세요." : "최근 시청한 기록이 없습니다.")
                        .font(.system(size: 11))
                        .foregroundColor(.white.opacity(0.5))
                        .multilineTextAlignment(.center)
                    Spacer()
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                ScrollView {
                    LazyVStack(spacing: 4) {
                        ForEach(items) { item in
                            ItemRowView(item: item, isCurrent: item.target == appState.currentTarget) {
                                appState.loadTarget(item.target, title: item.title)
                                appState.showHistorySheet = false
                            }
                        }
                    }
                    .padding(10)
                }
            }
        }
        .frame(width: 380, height: 260)
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
}

struct ItemRowView: View {
    let item: PlayHistoryItem
    let isCurrent: Bool
    let onSelect: () -> Void
    
    @State private var isHovered = false
    
    var body: some View {
        Button(action: onSelect) {
            HStack(spacing: 8) {
                Image(systemName: isCurrent ? "play.circle.fill" : "play.circle")
                    .font(.system(size: 14))
                    .foregroundColor(isCurrent ? .red : .white.opacity(0.7))
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(item.title)
                        .font(.system(size: 11, weight: isCurrent ? .bold : .medium))
                        .foregroundColor(isCurrent ? .white : .white.opacity(0.85))
                        .lineLimit(1)
                    
                    Text(formattedDate(item.timestamp))
                        .font(.system(size: 9))
                        .foregroundColor(.white.opacity(0.4))
                }
                
                Spacer()
                
                if isCurrent {
                    Text("재생중")
                        .font(.system(size: 9, weight: .semibold))
                        .foregroundColor(.red)
                        .padding(.horizontal, 5)
                        .padding(.vertical, 2)
                        .background(Color.red.opacity(0.2))
                        .cornerRadius(4)
                }
            }
            .padding(.horizontal, 10)
            .padding(.vertical, 6)
            .background(
                RoundedRectangle(cornerRadius: 6)
                    .fill(isHovered ? Color.white.opacity(0.1) : (isCurrent ? Color.white.opacity(0.05) : Color.clear))
            )
        }
        .buttonStyle(.plain)
        .onHover { isHovered = $0 }
    }
    
    private func formattedDate(_ date: Date) -> String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .short
        return formatter.localizedString(for: date, relativeTo: Date())
    }
}
