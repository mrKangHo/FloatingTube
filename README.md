# FloatingTube 📺

> **Floating YouTube Player for macOS**  
> 언제 어디서나 다른 작업을 방해하지 않고 유튜브를 감상할 수 있는 macOS 네이티브 플로팅 플레이어입니다.

[![Swift](https://img.shields.io/badge/Swift-5.9+-orange.svg)](https://swift.org)
[![macOS](https://img.shields.io/badge/macOS-13.0+-blue.svg)](https://apple.com/macos)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

---

## ✨ 핵심 기능 (Features)

* 📌 **항상 화면 위에 고정 (Always on Top)**: 코딩, 문서 작업, 웹 서핑 중에도 영상 창이 항상 최상단에 떠 있습니다.
* 🎬 **창 크기 맞춤 전체화면 (Window-Confined Fullscreen)**: 플로팅 창 크기(예: `340x200`)를 유지한 채로, 창 안에서 댓글/사이드바를 숨기고 영상만 100% 꽉 차게 재생합니다.
* 🌐 **클린 뷰 / 유튜브 웹 뷰 전환**: 순수 영상 전용 클린 뷰와 댓글/추천 영상이 보이는 유튜브 웹 뷰를 원클릭으로 전환할 수 있습니다.
* 🖱️ **마우스 관통 모드 (Click-Through)**: 영상을 띄워둔 상태에서 뒤쪽 앱을 그대로 클릭하고 스크롤할 수 있으며, 관통 모드 활성화 시 모든 컨트롤러가 완전히 숨겨져 영상만 깨끗하게 표시됩니다.
* 💧 **창 투명도 조절**: 30% ~ 100% 투명도 조절로 작업 화면 가림을 최소화합니다.
* 📐 **16:9 비율 고정**: 창 크기를 자유롭게 늘리고 줄여도 황금 비율인 16:9를 완벽하게 유지합니다.
* 🖥️ **macOS 메뉴바(상태표시줄) 트레이 지원**: 화면 상단 메뉴바 아이콘을 통해 모든 기능을 즉시 제어할 수 있습니다.
* 👤 **구글 / 유튜브 계정 로그인 유지**: 사파리 세션 저장소를 활용하여 로그인 상태가 유지됩니다.
* 📋 **클립보드 빠른 재생**: 유튜브 링크를 복사하고 `⌘ + V`만 누르면 즉시 재생됩니다.

---

## ⌨️ 단축키 안내 (Keyboard Shortcuts)

| 기능 | 단축키 | 설명 |
|---|---|---|
| **클립보드 링크 재생** | `⌘ + V` | 복사한 유튜브 링크 즉시 로딩 및 재생 |
| **항상 위에 고정 토글** | `⌘ + T` | 최상단 고정 켜기 / 끄기 |
| **마우스 관통 모드** | `⌘ + ⇧ + C` | 뒤쪽 앱 클릭 통과 & 컨트롤러 완전 숨김 |
| **창 맞춤 전체화면** | `F` 또는 `T` | 창 크기 내 100% 영상 채우기 (해제: `Esc`) |
| **재생 / 일시정지** | `Space` | 재생 및 멈춤 토글 |
| **음소거 토글** | `M` | 음소거 켜기 / 끄기 |
| **새로고침** | `⌘ + R` | 영상 페이지 새로고침 |
| **앱 종료** | `⌘ + Q` | FloatingTube 완전 종료 |

---

## 🛠️ 빌드 및 실행 방법 (Build & Run)

### 요구 사양
* macOS 13.0 (Ventura) 이상
* Xcode 15.0+ 또는 Swift 5.9+ Command Line Tools

### 빌드 스크립트 실행
```bash
# 1. 저장소 클론
git clone https://github.com/mrKangHo/FloatingTube.git
cd FloatingTube

# 2. 릴리즈 앱 번들 빌드
chmod +x scripts/bundle_app.sh
./scripts/bundle_app.sh

# 3. 앱 실행
open FloatingTube.app
```

---

## 📂 프로젝트 구조 (Architecture)

```
FloatingTube/
├── Sources/FloatingTube/
│   ├── FloatingTubeApp.swift         # 앱 엔트리포인트 및 상태표시줄(MenuBarExtra)
│   ├── Models/
│   │   └── AppState.swift            # 전역 반응형 상태 관리 (싱글톤)
│   ├── Services/
│   │   ├── WindowManager.swift       # AppKit 윈도우 레벨/투명도/마우스관통 제어
│   │   └── YouTubeURLParser.swift    # 링크 및 영상 ID 정규식 파서
│   └── Views/
│       ├── MainContainerView.swift   # 메인 뷰 컨테이너 및 단축키 모니터
│       ├── YouTubePlayerView.swift   # WKWebView 엔진 및 인앱 전체화면 스크립트
│       ├── HeaderControlBar.swift    # 슬림 상단 검색 & 컨트롤 바
│       ├── BottomControlBar.swift    # 미니멀 하단 플레이어 컨트롤 바
│       ├── MenuBarContentView.swift  # macOS 상태표시줄 트레이 메뉴
│       ├── HistorySheetView.swift    # 최근 시청 기록 및 즐겨찾기
│       └── ShortcutsSheetView.swift  # 단축키 안내 시트
├── Tests/FloatingTubeTests/          # 정밀 단위 테스트 (Unit Tests)
├── scripts/bundle_app.sh             # 자동 번들링 빌드 스크립트
└── Package.swift                     # Swift Package Manager 설정
```

---

## 📄 라이선스 (License)

이 프로젝트는 **[MIT License](LICENSE)**에 따라 배포됩니다.
