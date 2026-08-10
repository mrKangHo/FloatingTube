<div align="center">

# 📺 FloatingTube

### **Lightweight Floating YouTube Player for macOS**
*Always-on-Top Floating YouTube Player with In-App Fullscreen & Click-Through Mode*

[ 🇰🇷 한국어 ](README.md) | [ 🇺🇸 English ](README.en.md)

<br/>

[![Swift](https://img.shields.io/badge/Swift-5.9+-F05138.svg?style=flat&logo=swift&logoColor=white)](https://swift.org)
[![macOS](https://img.shields.io/badge/macOS-13.0%2B%20(Ventura%20%7C%20Sonoma%20%7C%20Sequoia)-000000.svg?style=flat&logo=apple&logoColor=white)](https://apple.com/macos)
[![Release](https://img.shields.io/github/v/release/mrKangHo/FloatingTube?color=brightgreen&label=Latest%20Release)](https://github.com/mrKangHo/FloatingTube/releases/latest)
[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg?style=flat)](LICENSE)

<br/>

<a href="https://github.com/mrKangHo/FloatingTube/releases/latest/download/FloatingTube-v1.0.0-macos.zip">
  <img src="https://img.shields.io/badge/📥_Download_FloatingTube-v1.0.0_(macOS)-2ea44f?style=for-the-badge&logo=apple&logoColor=white" alt="Download FloatingTube" height="42">
</a>

<br/><br/>

**Watch YouTube effortlessly while coding, designing, writing documents, or browsing without covering your workspace.**  
Going far beyond basic Picture-in-Picture (PiP) limitations, FloatingTube provides **Window-Confined In-App Fullscreen**, **Mouse Click-Through Mode**, **macOS Status Bar Tray Control**, **Login Persistence**, and a native macOS experience.

</div>

---

## 📥 Quick Download & Installation

You can use the latest pre-built application directly:

1. Click **[📥 Download FloatingTube (FloatingTube-v1.0.0-macos.zip)](https://github.com/mrKangHo/FloatingTube/releases/latest/download/FloatingTube-v1.0.0-macos.zip)**.
2. Unzip the downloaded `FloatingTube-v1.0.0-macos.zip` file.
3. Drag and drop **`FloatingTube.app`** into your **`/Applications`** folder.
4. Double-click to open and enjoy!

---

## 🌟 Key Features

### 1. 📌 Always on Top
* The floating player stays on top of all other application windows on your screen.
* Quickly toggle pinning via <kbd>⌘</kbd> + <kbd>T</kbd> or from the status bar menu.

### 2. 🎬 Window-Confined In-App Fullscreen
* **Does NOT take over your entire desktop space**: Preserves your chosen floating window dimensions (e.g. `340 × 200`, `512 × 288`).
* Clicking the YouTube player's fullscreen button (`[ ]`) or pressing <kbd>F</kbd> hides comments, sidebar, and headers, expanding the video to fill 100% of the floating window container.
* Pressing <kbd>Esc</kbd> or <kbd>F</kbd> instantly returns to the full YouTube web layout with comments.

### 3. 🖱️ Mouse Click-Through Mode
* Press <kbd>⌘</kbd> + <kbd>⇧</kbd> + <kbd>C</kbd> to pass all mouse clicks and scrolls directly to windows behind FloatingTube.
* **100% Concealed Controls**: While Click-Through mode is active, both the FloatingTube HUD and YouTube's internal controls/gradients are completely hidden, leaving only the pure video playing unobtrusively.

### 4. 🌐 Clean Mode vs. Web View Mode
* **Clean Mode**: Minimalist view focused solely on the video without recommendations or distractions.
* **Web View Mode**: Full YouTube website view allowing you to read comments, view playlists, and browse recommended videos.

### 5. 🖥️ macOS Status Bar (Menu Bar Extra) Tray
* A lightweight icon resides in your top-right macOS menu bar (next to clock / Wi-Fi) providing one-click access to all playback, opacity, and window controls.

### 6. 👤 Google & YouTube Login Session Persistence
* Leverages persistent WebKit storage (`WKWebsiteDataStore.default()`), keeping your subscriptions, playlist history, and personalized recommendations intact across restarts.

### 7. 📐 16:9 Aspect Ratio Lock & 💧 Opacity Adjustment
* Free-form window resizing with automatic 16:9 widescreen aspect ratio snapping.
* Adjustable transparency from 30% to 100% to let you see underlying content easily.

### 8. 📋 Quick Clipboard Paste & Play
* Copy any YouTube URL from your browser and press <kbd>⌘</kbd> + <kbd>V</kbd> to start playing immediately.

---

## ⌨️ Keyboard Shortcuts

| Shortcut | Action | Description |
|:---:|---|---|
| <kbd>⌘</kbd> + <kbd>V</kbd> | **Play Clipboard Link** | Automatically parse and load YouTube URL from clipboard |
| <kbd>⌘</kbd> + <kbd>T</kbd> | **Toggle Always on Top** | Pin / unpin player above other windows |
| <kbd>⌘</kbd> + <kbd>⇧</kbd> + <kbd>C</kbd> | **Click-Through Mode** | Pass clicks through player & completely hide controls |
| <kbd>F</kbd> or <kbd>T</kbd> | **In-App Fullscreen** | Expand video to fill floating window container |
| <kbd>Esc</kbd> | **Exit Fullscreen** | Restore comments and web sidebar layout |
| <kbd>Space</kbd> | **Play / Pause** | Toggle video playback |
| <kbd>M</kbd> | **Mute / Unmute** | Toggle audio mute |
| <kbd>⌘</kbd> + <kbd>R</kbd> | **Reload** | Refresh current video stream |
| <kbd>⌘</kbd> + <kbd>Q</kbd> | **Quit** | Exit FloatingTube |

---

## 🛠️ Build & Development

### Requirements
* macOS 13.0 (Ventura) or later
* Apple Silicon (M1/M2/M3/M4) or Intel x86_64 Mac
* Swift 5.9+ / Xcode 15.0+

### Build via Script
```bash
# 1. Clone repository
git clone https://github.com/mrKangHo/FloatingTube.git
cd FloatingTube

# 2. Build release bundle
chmod +x scripts/bundle_app.sh
./scripts/bundle_app.sh

# 3. Launch application
open FloatingTube.app
```

---

## 🏗️ Architecture & Tech Stack

FloatingTube is built purely with **native Apple Swift and AppKit/SwiftUI frameworks** without heavy Electron runtimes, ensuring minimal memory footprint and high battery efficiency.

* **Core UI**: SwiftUI + AppKit
* **Render Pipeline**: WebKit (`WKWebView`)
* **DOM Event Pipeline**: Shadow DOM Pierce (`e.composedPath()`) & Head Stylesheet Injection
* **State Management**: Combine (`ObservableObject`, `@Published`)
* **Window System**: `NSWindow` FullSizeContentView & Level Floating

---

## 📄 License

This project is licensed under the [MIT License](LICENSE).  
Feel free to use, modify, and distribute for personal or commercial projects.

<br/>

<div align="center">
Made with ❤️ by <a href="https://github.com/mrKangHo">mrKangHo</a>
</div>
