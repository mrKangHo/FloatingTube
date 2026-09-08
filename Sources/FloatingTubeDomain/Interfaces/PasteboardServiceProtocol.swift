import Foundation

public protocol PasteboardServiceProtocol: Sendable {
    func getCopiedString() -> String?
}
