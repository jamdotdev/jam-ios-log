import Foundation
import UIKit

extension UIApplication {
  fileprivate var firstKeyWindow: UIWindow? {
    connectedScenes.compactMap { $0 as? UIWindowScene }.first?.keyWindow
  }
}

extension UIWindow {
  fileprivate func registerForSceneCaptureStateChanges(completion: @escaping @MainActor (UISceneCaptureState) -> Void) {
    registerForTraitChanges([UITraitSceneCaptureState.self]) { (self: Self, _) in
      completion(self.traitCollection.sceneCaptureState)
    }
  }
}

@MainActor
class Logger {
  enum Reachability {
    case reachable
    case unreachable
    case unknown(Date)
  }

  public static let shared = Logger()

  private var stream: AsyncStream<LogMessage>
  private var continuation: AsyncStream<LogMessage>.Continuation

  private var reachability = Reachability.unreachable

  private init() {
    (stream, continuation) = AsyncStream.makeStream(of: LogMessage.self)

    let keyWindow = UIApplication.shared.firstKeyWindow

    reachability = keyWindow?.traitCollection.sceneCaptureState == .active ? .unknown(Date.now) : .unreachable

    keyWindow?.registerForSceneCaptureStateChanges { [weak self] sceneCaptureState in
      self?.reachability = sceneCaptureState == .active ? .unknown(Date.now) : .unreachable
    }

    Task {
      await processStream()
    }
  }

  public func log(_ logMessage: LogMessage) async {
    continuation.yield(logMessage)
  }

  private func processStream() async {
    for await logMessage in stream {
      switch reachability {
      case .reachable:
        do {
          try await post(logMessage)
        } catch {
          reachability = .unreachable
        }
      case .unreachable:
        break
      case .unknown(let date):
        // The scene is being captured but not necessarily by the Jam recorder.
        do {
          try await post(logMessage)

          reachability = .reachable
        } catch {
          // Allow more than enough time for the Jam recorder's server to start.
          if Date.now.timeIntervalSince(date) > 5 {
            reachability = .unreachable
          }
        }
      }
    }
  }

  private func post(_ logMessage: LogMessage) async throws {
    guard let httpBody = try? JSONEncoder().encode(logMessage) else { return }

    var request = URLRequest(url: URL(string: "http://localhost:3322/log")!)

    request.httpMethod = "POST"
    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    request.httpBody = httpBody

    _ = try await URLSession.shared.data(for: request)
  }
}
