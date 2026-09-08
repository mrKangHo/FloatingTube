import Foundation
import FloatingTubeDomain
import FloatingTubeData
import FloatingTubePresentation

@MainActor
public final class AppDIContainer {
    public static let shared = AppDIContainer()
    
    public let historyRepository: any HistoryRepositoryProtocol
    public let preferencesRepository: any PreferencesRepositoryProtocol
    public let pasteboardService: any PasteboardServiceProtocol
    public let windowManager: WindowManager
    
    public let resolveTargetUseCase: ResolveYouTubeTargetUseCase
    public let manageHistoryUseCase: ManageHistoryUseCase
    public let pasteAndResolveUseCase: PasteAndResolveUseCase
    public let preferencesUseCase: ManagePreferencesUseCase
    
    public let appState: AppState
    
    public init() {
        let historyRepo = UserDefaultsHistoryRepository()
        let prefRepo = UserDefaultsPreferencesRepository()
        let pasteboard = NSPasteboardService()
        let winMgr = WindowManager.shared
        
        let resolveUseCase = ResolveYouTubeTargetUseCase()
        let historyUseCase = ManageHistoryUseCase(historyRepository: historyRepo)
        let pasteResolveUseCase = PasteAndResolveUseCase(pasteboardService: pasteboard, resolveTargetUseCase: resolveUseCase)
        let prefUseCase = ManagePreferencesUseCase(preferencesRepository: prefRepo)
        
        let state = AppState(
            resolveTargetUseCase: resolveUseCase,
            manageHistoryUseCase: historyUseCase,
            pasteAndResolveUseCase: pasteResolveUseCase,
            preferencesUseCase: prefUseCase,
            windowManager: winMgr
        )
        
        self.historyRepository = historyRepo
        self.preferencesRepository = prefRepo
        self.pasteboardService = pasteboard
        self.windowManager = winMgr
        self.resolveTargetUseCase = resolveUseCase
        self.manageHistoryUseCase = historyUseCase
        self.pasteAndResolveUseCase = pasteResolveUseCase
        self.preferencesUseCase = prefUseCase
        self.appState = state
        
        // Sync singleton shared instance
        AppState.shared = state
    }
}
