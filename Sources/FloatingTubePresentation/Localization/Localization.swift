import Foundation

public enum Language: String, CaseIterable {
    case korean = "ko"
    case english = "en"
    
    public static var current: Language {
        let preferred = Locale.preferredLanguages.first ?? Locale.current.identifier
        if preferred.starts(with: "ko") {
            return .korean
        }
        return .english
    }
}

public struct L10n {
    private static var isKorean: Bool {
        return Language.current == .korean
    }
    
    // Header & Player
    public static var searchPlaceholder: String {
        isKorean ? "유튜브 링크 또는 ID 입력..." : "Enter YouTube URL or Video ID..."
    }
    public static var playClipboardTooltip: String {
        isKorean ? "클립보드 링크 붙여넣기 및 재생 (⌘V)" : "Paste clipboard link and play (⌘V)"
    }
    public static var alwaysOnTopTooltip: String {
        isKorean ? "항상 화면 위에 고정 (⌘T)" : "Always on Top (⌘T)"
    }
    public static var cleanViewTooltip: String {
        isKorean ? "클린 뷰 (영상 100% 꽉 찬 화면)" : "Clean Player View (100% Video)"
    }
    public static var webViewTooltip: String {
        isKorean ? "유튜브 웹 뷰 (댓글/사이드바)" : "YouTube Web View (Comments & Sidebar)"
    }
    public static var currentCleanModeHelp: String {
        isKorean ? "현재: 클린 플레이어 뷰 (클릭 시 웹 뷰로 전환)" : "Current: Clean View (Click for Web View)"
    }
    public static var currentWebModeHelp: String {
        isKorean ? "현재: 유튜브 웹 뷰 (클릭 시 클린 뷰로 전환)" : "Current: Web View (Click for Clean View)"
    }
    public static var inAppFullscreenTooltip: String {
        isKorean ? "창 맞춤 전체화면 토글 (F)" : "Toggle In-App Fullscreen (F)"
    }
    public static var openInBrowserTooltip: String {
        isKorean ? "기본 브라우저에서 열기" : "Open in Default Browser"
    }
    
    // Status Bar & App Commands
    public static var appTitleDefault: String {
        isKorean ? "FloatingTube 플레이어" : "FloatingTube Player"
    }
    public static var playClipboardLink: String {
        isKorean ? "클립보드 링크 재생" : "Play Clipboard Link"
    }
    public static var play: String {
        isKorean ? "재생" : "Play"
    }
    public static var pause: String {
        isKorean ? "일시정지" : "Pause"
    }
    public static var mute: String {
        isKorean ? "음소거" : "Mute"
    }
    public static var unmute: String {
        isKorean ? "음소거 해제" : "Unmute"
    }
    public static var reloadVideo: String {
        isKorean ? "영상 새로고침" : "Reload Video"
    }
    public static var alwaysOnTop: String {
        isKorean ? "항상 화면 위에 고정" : "Always on Top"
    }
    public static var cleanPlayerView: String {
        isKorean ? "클린 뷰 (영상 100% 꽉 찬 화면)" : "Clean Player View (100% Video)"
    }
    public static var youtubeWebView: String {
        isKorean ? "유튜브 웹 뷰 (댓글/사이드바)" : "YouTube Web View (Comments & Sidebar)"
    }
    public static var toggleFullscreen: String {
        isKorean ? "창 맞춤 전체화면 토글" : "Toggle In-App Fullscreen"
    }
    public static var opacityMenu: String {
        isKorean ? "창 투명도" : "Window Opacity"
    }
    public static var opacity100: String {
        isKorean ? "100% (불투명)" : "100% (Opaque)"
    }
    public static var opacity80: String {
        isKorean ? "80% (약간 투명)" : "80%"
    }
    public static var opacity50: String {
        isKorean ? "50% (반투명)" : "50%"
    }
    public static var opacity30: String {
        isKorean ? "30% (투명)" : "30% (Transparent)"
    }
    public static var lockAspectRatio: String {
        isKorean ? "16:9 화면비율 잠금" : "Lock 16:9 Aspect Ratio"
    }
    public static var clickThroughMode: String {
        isKorean ? "마우스 관통 모드" : "Click-Through Mode"
    }
    public static var googleLogin: String {
        isKorean ? "구글 / 유튜브 계정 로그인" : "Sign in with Google / YouTube"
    }
    public static var addBookmark: String {
        isKorean ? "현재 영상 즐겨찾기 추가" : "Add to Bookmarks"
    }
    public static var historySheet: String {
        isKorean ? "최근 재생 및 즐겨찾기 목록..." : "History & Bookmarks..."
    }
    public static var shortcutsSheet: String {
        isKorean ? "단축키 안내..." : "Keyboard Shortcuts..."
    }
    public static var quitApp: String {
        isKorean ? "FloatingTube 종료" : "Quit FloatingTube"
    }
    public static var viewMenu: String {
        isKorean ? "보기" : "View"
    }
    
    // Toast Status Messages
    public static var statusCleanMode: String {
        isKorean ? "클린 뷰 모드" : "Clean View Mode"
    }
    public static var statusWebMode: String {
        isKorean ? "유튜브 웹 뷰 모드" : "YouTube Web Mode"
    }
    public static var statusInvalidUrl: String {
        isKorean ? "유효한 유튜브 주소가 아닙니다." : "Invalid YouTube URL"
    }
    public static var statusLoadingVideo: String {
        isKorean ? "영상 로딩 중..." : "Loading video..."
    }
    public static var statusPlayingClipboard: String {
        isKorean ? "클립보드 주소 재생" : "Playing clipboard URL"
    }
    public static var statusNoClipboardText: String {
        isKorean ? "클립보드에 텍스트가 없습니다." : "No text in clipboard"
    }
    public static var statusNoClipboardUrl: String {
        isKorean ? "클립보드에 유튜브 주소가 없습니다." : "No YouTube URL found in clipboard"
    }
    public static var statusAlwaysOnTopEnabled: String {
        isKorean ? "항상 위에 고정됨" : "Always on Top Enabled"
    }
    public static var statusAlwaysOnTopDisabled: String {
        isKorean ? "고정 해제됨" : "Always on Top Disabled"
    }
    public static var statusAspectRatioLocked: String {
        isKorean ? "16:9 비율 고정됨" : "16:9 Ratio Locked"
    }
    public static var statusAspectRatioFree: String {
        isKorean ? "자유 비율 조절" : "Free Aspect Ratio"
    }
    public static var statusClickThroughOn: String {
        isKorean ? "클릭 관통 모드 켜짐 (해제: 단축키 ⌘⇧C)" : "Click-Through Mode ON (Disable: ⌘⇧C)"
    }
    public static var statusClickThroughOff: String {
        isKorean ? "클릭 관통 모드 해제됨" : "Click-Through Mode OFF"
    }
    public static var statusBookmarkAdded: String {
        isKorean ? "즐겨찾기에 추가됨" : "Added to Bookmarks"
    }
    public static var statusBookmarkRemoved: String {
        isKorean ? "즐겨찾기 삭제됨" : "Removed from Bookmarks"
    }
    public static var statusHistoryCleared: String {
        isKorean ? "시청 기록이 삭제되었습니다." : "Watch history cleared"
    }
    public static var statusInAppFullscreen: String {
        isKorean ? "창 맞춤 전체화면 (해제: Esc 또는 F)" : "In-App Fullscreen (Exit: Esc or F)"
    }
    public static var statusReturnToWeb: String {
        isKorean ? "유튜브 웹 화면으로 복귀" : "Returned to Web View"
    }
    public static var statusLoginRedirect: String {
        isKorean ? "구글 로그인 화면으로 이동합니다." : "Opening Google sign-in..."
    }
    
    // Sheets
    public static var historyTitle: String {
        isKorean ? "시청 기록 및 즐겨찾기" : "History & Bookmarks"
    }
    public static var recentHistory: String {
        isKorean ? "최근 시청 기록" : "Recent History"
    }
    public static var bookmarksTab: String {
        isKorean ? "즐겨찾기" : "Bookmarks"
    }
    public static var clearHistoryButton: String {
        isKorean ? "기록 비우기" : "Clear History"
    }
    public static var noHistoryYet: String {
        isKorean ? "시청 기록이 없습니다." : "No watch history yet."
    }
    public static var noBookmarksYet: String {
        isKorean ? "즐겨찾기한 영상이 없습니다." : "No bookmarked videos yet."
    }
    public static var closeButton: String {
        isKorean ? "닫기" : "Close"
    }
    public static var shortcutsTitle: String {
        isKorean ? "키보드 단축키 안내" : "Keyboard Shortcuts"
    }
}
