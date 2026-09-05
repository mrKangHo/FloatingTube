import Foundation
import AppKit
import FloatingTubeDomain

public final class NSPasteboardService: PasteboardServiceProtocol, @unchecked Sendable {
    public init() {}
    
    public func getCopiedString() -> String? {
        return NSPasteboard.general.string(forType: .string)
    }
}
