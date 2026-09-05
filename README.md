<div align="center">

<img src="Sources/FloatingTube/Resources/AppIcon.png" width="128" height="128" alt="FloatingTube Logo" />

# 📺 FloatingTube

### **macOS 전용 초경량 플로팅 유튜브 플레이어**
*Always-on-Top Floating YouTube Player with In-App Fullscreen & Click-Through Mode*

[ 🇰🇷 한국어 ](README.md) | [ 🇺🇸 English ](README.en.md)

<br/>

[![Swift](https://img.shields.io/badge/Swift-5.9+-F05138.svg?style=flat&logo=swift&logoColor=white)](https://swift.org)
[![macOS](https://img.shields.io/badge/macOS-13.0%2B%20(Ventura%20%7C%20Sonoma%20%7C%20Sequoia)-000000.svg?style=flat&logo=apple&logoColor=white)](https://apple.com/macos)
[![Release](https://img.shields.io/github/v/release/mrKangHo/FloatingTube?color=brightgreen&label=Latest%20Release)](https://github.com/mrKangHo/FloatingTube/releases/latest)
[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg?style=flat)](LICENSE)

<br/>

<a href="https://github.com/mrKangHo/FloatingTube/releases/latest/download/FloatingTube-v1.1.0-macos.zip">
  <img src="https://img.shields.io/badge/📥_Download_FloatingTube-v1.1.0_(macOS)-2ea44f?style=for-the-badge&logo=apple&logoColor=white" alt="Download FloatingTube" height="42">
</a>

<br/><br/>

**코딩, 디자인, 문서 작업, 웹 서핑 중에도 작업 화면을 가리지 않고 유튜브를 자유롭게 감상하세요.**  
기본 PiP(화면 속 화면)의 제한을 뛰어넘어, **창 크기 맞춤 전체화면**, **마우스 관통 모드**, **상태표시줄 제어**, **로그인 유지** 등 완벽한 멀티태스킹 환경을 제공합니다.

</div>

---

## 📥 간편 다운로드 및 설치 (Download & Install)

소스를 직접 빌드하지 않고 완성된 최신 앱을 바로 사용하실 수 있습니다:

1. **[📥 최신 버전 다운로드 (FloatingTube-v1.1.0-macos.zip)](https://github.com/mrKangHo/FloatingTube/releases/latest/download/FloatingTube-v1.1.0-macos.zip)** 링크를 클릭하여 다운로드합니다.
2. 다운로드된 `FloatingTube-v1.1.0-macos.zip`의 압축을 풉니다.
3. 압축 해제된 **`FloatingTube.app`**을 **응용 프로그램(Applications)** 폴더로 드래그하여 이동합니다.
4. 앱을 더블 클릭하여 실행합니다.

---

## 🌟 주요 핵심 기능 (Key Features)

### 1. 📌 항상 화면 위에 고정 (Always on Top)
* 어떤 앱을 사용하든 플로팅 창이 최상단에 상시 유지됩니다.
* 단축키 `⌘ + T` 또는 상태표시줄 메뉴에서 원클릭으로 고정/해제가 가능합니다.

### 2. 🎬 창 맞춤 인앱 전체화면 (Window-Confined Fullscreen)
* **데스크톱 전체화면으로 넘어가지 않습니다**: 사용자가 설정한 플로팅 창 크기(예: `340 × 200`, `512 × 288`)를 그대로 유지합니다.
* 유튜브 플레이어의 전체화면 버튼(`[ ]`) 또는 `F` 키를 누르면, **창 내부에서 댓글/사이드바/헤더를 모두 숨기고 오직 영상 플레이어만 창 크기에 100% 꽉 차게 전환**됩니다.
* `Esc` 또는 `F` 키를 누르면 댓글과 추천 영상이 있는 원래 웹 화면으로 즉시 복귀합니다.

### 3. 🖱️ 마우스 관통 모드 (Click-Through Mode)
* 단축키 `⌘ + ⇧ + C`를 누르면 창이 완전히 마우스 이벤트를 통과시킵니다.
* **유튜브 자체 컨트롤러 & 앱 메뉴바 100% 은폐**: 관통 모드 중에는 마우스가 올라가도 플레이어 컨트롤러가 일절 나타나지 않아 뒤쪽 화면의 텍스트나 버튼을 아무런 방해 없이 클릭/스크롤할 수 있습니다.

### 4. 🌐 클린 뷰 & 웹 뷰 모드 자유 전환
* **클린 뷰 (Clean Mode)**: 방해 요소 없이 오직 영상만 미니멀하게 감상하는 모드입니다.
* **유튜브 웹 뷰 (Web Mode)**: 유튜브 원본 사이트 그대로 댓글 작성, 추천 영상 탐색, 플레이리스트 확인이 가능한 모드입니다.

### 5. 🖥️ macOS 상단 상태표시줄(Status Bar) 트레이 완벽 지원
* 화면 맨 위 우측 메뉴바(시계 옆)에 상주하는 트레이 아이콘을 통해 모든 부가 기능과 제어를 손쉽게 관리할 수 있습니다.
* 플로팅 창 위의 번잡한 버튼들을 모두 정리하여 극도로 깔끔한 화면을 유지합니다.

### 6. 👤 구글 / 유튜브 계정 로그인 유지
* macOS 전용 영구 쿠키 및 세션 저장소(`WKWebsiteDataStore.default()`)를 활용하여 구독 채널, 알고리즘 맞춤 추천, 시청 기록이 그대로 유지됩니다.

### 7. 📐 16:9 화면비율 잠금 & 💧 투명도 조절
* 모서리를 드래그해 자유롭게 창 크기를 조절해도 16:9 황금 비율을 자동으로 유지합니다.
* 30% ~ 100% 투명도 조절을 지원하여 중요한 작업 화면 뒤의 내용을 은은하게 투과하여 볼 수 있습니다.

### 8. 📋 클립보드 빠른 재생 (Paste & Play)
* 브라우저에서 유튜브 링크를 복사한 후 `⌘ + V`를 누르면 즉시 해당 영상이 로딩되어 재생됩니다.

---

## ⌨️ 단축키 안내 (Keyboard Shortcuts)

| 단축키 | 기능 | 설명 |
|:---:|---|---|
| <kbd>⌘</kbd> + <kbd>V</kbd> | **클립보드 링크 재생** | 클립보드에 복사된 유튜브 URL 또는 영상 ID 즉시 로드 |
| <kbd>⌘</kbd> + <kbd>T</kbd> | **항상 위에 고정 토글** | 최상단 플로팅 켜기 / 끄기 |
| <kbd>⌘</kbd> + <kbd>⇧</kbd> + <kbd>C</kbd> | **마우스 관통 모드** | 뒤쪽 앱 클릭 통과 & 모든 컨트롤러 자동 은폐 |
| <kbd>F</kbd> 또는 <kbd>T</kbd> | **창 맞춤 전체화면** | 플로팅 창 내부 100% 꽉 찬 화면 토글 |
| <kbd>Esc</kbd> | **전체화면 해제** | 댓글/사이드바가 보이는 웹 화면으로 복귀 |
| <kbd>Space</kbd> | **재생 / 일시정지** | 영상 재생 및 멈춤 토글 (자동 재시작 방지) |
| <kbd>M</kbd> | **음소거 토글** | 소리 끄기 / 켜기 |
| <kbd>⌘</kbd> + <kbd>R</kbd> | **새로고침** | 영상 페이지 새로고침 |
| <kbd>⌘</kbd> + <kbd>Q</kbd> | **앱 종료** | FloatingTube 완전 종료 |

---

## 🛠️ 빌드 및 설치 방법 (Build & Installation)

### 요구 사양 (System Requirements)
* **OS**: macOS 13.0 (Ventura) 이상
* **Architecture**: Apple Silicon (M1/M2/M3/M4) 및 Intel x86_64 모두 완벽 지원
* **Tools**: Swift 5.9+ / Xcode 15.0+ / Tuist 4.x+

### Tuist로 Xcode 프로젝트 생성 및 개발하기 (권장)
```bash
# 1. 저장소 복제
git clone https://github.com/mrKangHo/FloatingTube.git
cd FloatingTube

# 2. Tuist 프로젝트 및 워크스페이스 생성
tuist generate

# 3. FloatingTube.xcworkspace가 생성되며 Xcode에서 즉시 실행/디버깅 가능
```

### 빌드 스크립트로 번들링하기 (CLI)
```bash
# 릴리즈 앱 번들 생성 스크립트 실행
chmod +x scripts/bundle_app.sh
./scripts/bundle_app.sh

# 앱 실행
open FloatingTube.app
```

---

## 🏗️ 클린 아키텍처 및 모듈 구조 (Clean Architecture)

FloatingTube는 관심사의 완벽한 분리와 높은 테스트 용이성을 보장하기 위해 **클린 아키텍처(Clean Architecture)** 및 **Tuist 기반 멀티 모듈** 설계를 채택하였습니다.

```mermaid
graph TD
    subgraph Presentation [FloatingTubePresentation]
        V[SwiftUI Views] --> VM[AppState ViewModel]
        VM --> WMP[WindowManager]
    end

    subgraph Domain [FloatingTubeDomain - Core Business Logic]
        E[Entities: YouTubeTarget, PlayHistoryItem, WindowPreferences]
        U1[ResolveYouTubeTargetUseCase]
        U2[ManageHistoryUseCase]
        U3[PasteAndResolveUseCase]
        U4[ManagePreferencesUseCase]
        R1[HistoryRepositoryProtocol]
        R2[PreferencesRepositoryProtocol]
        R3[PasteboardServiceProtocol]
        R4[WindowManagerProtocol]
    end

    subgraph Data [FloatingTubeData - Implementation]
        DR1[UserDefaultsHistoryRepository] --> R1
        DR2[UserDefaultsPreferencesRepository] --> R2
        DS1[NSPasteboardService] --> R3
    end

    subgraph App [FloatingTube App Target]
        Main[FloatingTubeApp] --> DI[AppDIContainer]
    end

    VM --> U1
    VM --> U2
    VM --> U3
    VM --> U4
    WMP --> R4
    DI --> Data
    DI --> Domain
    DI --> Presentation
```

* **FloatingTubeDomain**: 외부 의존성(AppKit/SwiftUI/UserDefaults)이 전혀 없는 순수 비즈니스 로직, 엔티티, 유스케이스, 리포지토리 인터페이스.
* **FloatingTubeData**: `UserDefaults`, `NSPasteboard` 등 외부 플랫폼/데이터 저장소를 사용하는 리포지토리 및 서비스 구현체.
* **FloatingTubePresentation**: SwiftUI 뷰, AppState 뷰모델, 컴포넌트, 다국어(L10n) 및 윈도우 매니저.
* **FloatingTube (App)**: 의존성 주입(`AppDIContainer`), 앱 수명주기(`FloatingTubeApp`), 메뉴바 엑스트라 및 리소스.

---

## 📁 디렉토리 구조 (Directory Structure)

```
FloatingTube/
├── Project.swift                          # Tuist 프로젝트 매니페스트 (멀티 타깃 정의)
├── Package.swift                          # SPM 패키지 매니페스트
├── Sources/
│   ├── FloatingTube/                      # [App Target] 애플리케이션 진입점 & DI
│   │   ├── FloatingTubeApp.swift          # @main 앱 시작점 & MenuBarExtra
│   │   ├── AppDIContainer.swift           # 의존성 주입 컨테이너 (Composition Root)
│   │   └── Resources/                     # AppIcon.icns, AppIcon.png
│   ├── FloatingTubeDomain/                # [Domain Layer] 순수 비즈니스 도메인
│   │   ├── Entities/                      # YouTubeTarget, PlayHistoryItem, WindowPreferences
│   │   ├── Interfaces/                    # Repository & Service Protocols
│   │   └── UseCases/                      # ResolveTarget, ManageHistory, PasteResolve 등
│   ├── FloatingTubeData/                  # [Data Layer] 인프라 및 저장소 구현체
│   │   ├── Repositories/                  # UserDefaultsHistoryRepository 등
│   │   └── Services/                      # NSPasteboardService
│   └── FloatingTubePresentation/          # [Presentation Layer] UI & ViewModel
│       ├── ViewModels/                    # AppState
│       ├── Services/                      # WindowManager, WindowAccessor
│       ├── Localization/                  # Localization (L10n, Language)
│       └── Views/                         # MainContainerView, YouTubePlayerView 등
├── Tests/
│   ├── FloatingTubeDomainTests/           # 도메인 유스케이스 & 파서 단위 테스트
│   └── FloatingTubeDataTests/             # 저장소 직렬화 & 영속화 단위 테스트
└── scripts/
    └── bundle_app.sh                      # 릴리즈 자동 번들링 스크립트
```

---

## 📄 라이선스 (License)

이 프로젝트는 [MIT License](LICENSE)에 따라 오픈 소스로 배포됩니다.
자유롭게 수정, 배포 및 상업적 이용이 가능합니다.

<br/>

<div align="center">
Made with ❤️ by <a href="https://github.com/mrKangHo">mrKangHo</a>
</div>
