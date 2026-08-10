import SwiftUI
import WebKit
import Combine

public struct YouTubePlayerView: NSViewRepresentable {
    @ObservedObject var appState: AppState
    
    public init(appState: AppState) {
        self.appState = appState
    }
    
    public func makeCoordinator() -> Coordinator {
        Coordinator(appState: appState)
    }
    
    public func makeNSView(context: Context) -> WKWebView {
        let config = WKWebViewConfiguration()
        config.mediaTypesRequiringUserActionForPlayback = []
        config.allowsAirPlayForMediaPlayback = true
        config.defaultWebpagePreferences.allowsContentJavaScript = true
        config.websiteDataStore = WKWebsiteDataStore.default()
        config.preferences.setValue(false, forKey: "fullScreenEnabled")
        config.preferences.setValue(true, forKey: "developerExtrasEnabled")
        
        let userContentController = WKUserContentController()
        userContentController.add(context.coordinator, name: "tubeBridge")
        
        let fsCSS = """
        #masthead-container, #masthead, #secondary, #below, #comments, #chat, #chat-container, ytd-live-chat-frame, #guide, ytd-mini-guide-renderer, #ticket-shelf, ytd-merch-shelf-renderer, #header, #voice-search-button, ytd-searchbox, #guide-wrapper {
            display: none !important;
        }

        html, body {
            margin: 0 !important;
            padding: 0 !important;
            overflow: hidden !important;
            background-color: #000000 !important;
            width: 100vw !important;
            height: 100vh !important;
        }

        #page-manager {
            margin-top: 0 !important;
            padding: 0 !important;
        }

        ytd-watch-flexy,
        ytd-watch-grid,
        #columns,
        #primary,
        #primary-inner {
            padding: 0 !important;
            margin: 0 !important;
            width: 100vw !important;
            height: 100vh !important;
            max-width: 100vw !important;
            max-height: 100vh !important;
            min-width: 100vw !important;
        }

        #player,
        #player-container,
        #player-container-outer,
        #player-container-inner,
        #ytd-player,
        #movie_player,
        .html5-video-player {
            position: fixed !important;
            top: 0 !important;
            left: 0 !important;
            width: 100vw !important;
            height: 100vh !important;
            max-width: 100vw !important;
            max-height: 100vh !important;
            margin: 0 !important;
            padding: 0 !important;
            z-index: 2147483647 !important;
            border-radius: 0 !important;
            background: #000000 !important;
        }

        video.html5-main-video {
            width: 100vw !important;
            height: 100vh !important;
            top: 0 !important;
            left: 0 !important;
            object-fit: contain !important;
        }
        """
        
        let initialClean = appState.isCleanMode
        let script = """
        (function() {
            var cssText = `\(fsCSS.replacingOccurrences(of: "\n", with: " "))`;
            window.__isCleanEnabled = \(initialClean);

            function isFsActive() {
                return !!document.getElementById('floating-tube-fs-style');
            }

            function setFullscreen(enable) {
                window.__isCleanEnabled = enable;
                var existing = document.getElementById('floating-tube-fs-style');
                if (enable) {
                    if (!existing) {
                        var style = document.createElement('style');
                        style.id = 'floating-tube-fs-style';
                        style.textContent = cssText;
                        (document.head || document.documentElement).appendChild(style);
                    }
                } else {
                    if (existing) {
                        existing.remove();
                    }
                }
                window.dispatchEvent(new Event('resize'));
                post({
                    type: 'status',
                    message: enable ? "창 맞춤 전체화면 (해제: Esc 또는 F)" : "유튜브 웹 화면으로 복귀"
                });
            }

            window.toggleCleanMode = function(enable) {
                setFullscreen(enable);
            };

            window.toggleInAppFullscreen = function() {
                setFullscreen(!isFsActive());
            };

            window.setClickThroughMode = function(enabled) {
                var el = document.getElementById('floating-tube-clickthrough-style');
                if (enabled) {
                    if (!el) {
                        el = document.createElement('style');
                        el.id = 'floating-tube-clickthrough-style';
                        el.textContent = `
                            .ytp-chrome-bottom,
                            .ytp-chrome-top,
                            .ytp-gradient-bottom,
                            .ytp-gradient-top,
                            .ytp-pause-overlay,
                            .ytp-ce-element,
                            .ytp-cards-teaser,
                            .ytp-paid-content-overlay,
                            .ytp-bezel-text-wrapper,
                            .ytp-bezel,
                            .ytp-spinner {
                                display: none !important;
                                opacity: 0 !important;
                                visibility: hidden !important;
                                pointer-events: none !important;
                            }
                        `;
                        (document.head || document.documentElement).appendChild(el);
                    }
                } else {
                    if (el) {
                        el.remove();
                    }
                }
            };

            // Set initial state
            if (window.__isCleanEnabled) {
                setFullscreen(true);
            }

            // Capture clicks on Fullscreen / Theater buttons through Shadow DOM
            document.addEventListener('click', function(e) {
                var path = (e.composedPath && e.composedPath()) || [];
                var isFs = false;
                for (var i = 0; i < path.length; i++) {
                    var el = path[i];
                    if (el && el.nodeType === 1) {
                        var cls = el.className || '';
                        if (typeof cls === 'string' && (cls.includes('ytp-fullscreen-button') || cls.includes('ytp-size-button'))) {
                            isFs = true;
                            break;
                        }
                        var aria = (el.getAttribute('aria-label') || el.getAttribute('data-title-no-tooltip') || el.title || '').toLowerCase();
                        if (aria.includes('전체') || aria.includes('full') || aria.includes('영화관') || aria.includes('theater')) {
                            isFs = true;
                            break;
                        }
                    }
                }
                if (isFs) {
                    e.preventDefault();
                    e.stopPropagation();
                    window.toggleInAppFullscreen();
                }
            }, true);

            // Double click on video to toggle in-app fullscreen
            document.addEventListener('dblclick', function(e) {
                var path = (e.composedPath && e.composedPath()) || [];
                var isVideo = path.some(function(el) {
                    return el && el.nodeType === 1 && (el.tagName === 'VIDEO' || (el.classList && el.classList.contains('html5-video-player')));
                });
                if (isVideo) {
                    e.preventDefault();
                    e.stopPropagation();
                    window.toggleInAppFullscreen();
                }
            }, true);

            // Keyboard shortcuts 'F', 'T', 'Escape'
            document.addEventListener('keydown', function(e) {
                var tag = (document.activeElement && document.activeElement.tagName) || '';
                if (tag === 'INPUT' || tag === 'TEXTAREA' || (document.activeElement && document.activeElement.isContentEditable)) {
                    return;
                }
                if (e.key === 'f' || e.key === 'F' || e.key === 't' || e.key === 'T') {
                    e.preventDefault();
                    e.stopPropagation();
                    window.toggleInAppFullscreen();
                } else if (e.key === 'Escape') {
                    if (isFsActive()) {
                        e.preventDefault();
                        e.stopPropagation();
                        setFullscreen(false);
                    }
                }
            }, true);

            // Periodic helper for consent dialogs and video state sync
            function runLoop() {
                if (window.__isCleanEnabled && !isFsActive()) {
                    setFullscreen(true);
                }
                
                // Auto click Google / YouTube consent if shown
                var btns = document.querySelectorAll('button, tp-yt-paper-button, .yt-spec-button-shape-next');
                btns.forEach(function(b) {
                    var t = (b.innerText || '').toLowerCase();
                    if (t.includes('동의') || t.includes('accept') || t.includes('i agree') || t.includes('모두 수락')) {
                        b.click();
                    }
                });

                var video = document.querySelector('video');
                if (video && !video.__hasTubeListeners) {
                    video.__hasTubeListeners = true;
                    video.addEventListener('play', function() {
                        post({ type: 'stateChange', state: 1 });
                    });
                    video.addEventListener('pause', function() {
                        post({ type: 'stateChange', state: 2 });
                    });
                    video.addEventListener('loadedmetadata', function() {
                        post({ type: 'ready' });
                        extractTitle();
                    });
                }
                extractTitle();
            }

            function extractTitle() {
                var title = "";
                var h1 = document.querySelector('h1.ytd-watch-metadata yt-formatted-string');
                if (h1 && h1.innerText) {
                    title = h1.innerText;
                } else {
                    title = document.title.replace(" - YouTube", "").trim();
                }
                if (title && title.length > 0 && title !== "YouTube") {
                    post({ type: 'title', title: title });
                }
            }

            function post(msg) {
                if (window.webkit && window.webkit.messageHandlers && window.webkit.messageHandlers.tubeBridge) {
                    window.webkit.messageHandlers.tubeBridge.postMessage(msg);
                }
            }

            if (document.readyState === 'loading') {
                document.addEventListener('DOMContentLoaded', runLoop);
            } else {
                runLoop();
            }
            setInterval(runLoop, 2000);
        })();
        """
        
        let userScript = WKUserScript(
            source: script,
            injectionTime: .atDocumentEnd,
            forMainFrameOnly: false
        )
        userContentController.addUserScript(userScript)
        config.userContentController = userContentController
        
        let webView = CustomWKWebView(frame: .zero, configuration: config)
        webView.navigationDelegate = context.coordinator
        webView.setValue(false, forKey: "drawsBackground")
        webView.customUserAgent = "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/17.4 Safari/605.1.15"
        
        context.coordinator.webView = webView
        context.coordinator.subscribeToCommands()
        
        loadTarget(webView: webView, target: appState.currentTarget)
        return webView
    }
    
    public func updateNSView(_ webView: WKWebView, context: Context) {
        if context.coordinator.lastLoadedTarget != appState.currentTarget {
            loadTarget(webView: webView, target: appState.currentTarget)
        }
    }
    
    private func loadTarget(webView: WKWebView, target: YouTubeTarget?) {
        guard let target = target, let url = URL(string: target.watchURLString) else { return }
        
        var request = URLRequest(url: url)
        request.setValue("https://www.youtube.com", forHTTPHeaderField: "Referer")
        webView.load(request)
    }
    
    public class Coordinator: NSObject, WKNavigationDelegate, WKScriptMessageHandler {
        var appState: AppState
        weak var webView: WKWebView?
        var lastLoadedTarget: YouTubeTarget?
        private var cancellables = Set<AnyCancellable>()
        
        init(appState: AppState) {
            self.appState = appState
        }
        
        func subscribeToCommands() {
            appState.webViewCommandPublisher
                .receive(on: DispatchQueue.main)
                .sink { [weak self] command in
                    self?.handleCommand(command)
                }
                .store(in: &cancellables)
        }
        
        private func handleCommand(_ command: String) {
            guard let webView = webView else { return }
            
            let script: String
            switch command {
            case "player.playVideo();":
                script = "var v = document.querySelector('video'); if (v) v.play();"
            case "player.pauseVideo();":
                script = "var v = document.querySelector('video'); if (v) v.pause();"
            case "player.mute();":
                script = "var v = document.querySelector('video'); if (v) v.muted = true;"
            case "player.unMute();":
                script = "var v = document.querySelector('video'); if (v) v.muted = false;"
            case "player.toggleFullscreen();":
                script = "window.toggleInAppFullscreen();"
            case "location.reload();":
                script = "location.reload();"
            default:
                script = command
            }
            
            webView.evaluateJavaScript(script, completionHandler: nil)
        }
        
        public func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            lastLoadedTarget = appState.currentTarget
            appState.isLoading = false
        }
        
        public func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
            guard let dict = message.body as? [String: Any],
                  let type = dict["type"] as? String else { return }
            
            Task { @MainActor in
                switch type {
                case "ready":
                    self.appState.isLoading = false
                case "stateChange":
                    if let state = dict["state"] as? Int {
                        self.appState.isPlaying = (state == 1)
                    }
                case "title":
                    if let title = dict["title"] as? String, !title.isEmpty {
                        self.appState.videoTitle = title
                        if let current = self.appState.currentTarget {
                            self.appState.addToHistory(target: current, title: title)
                        }
                    }
                case "status":
                    if let msg = dict["message"] as? String {
                        self.appState.showStatus(msg)
                    }
                default:
                    break
                }
            }
        }
    }
}

public class CustomWKWebView: WKWebView {
    public override func scrollWheel(with event: NSEvent) {
        super.scrollWheel(with: event)
    }
}
