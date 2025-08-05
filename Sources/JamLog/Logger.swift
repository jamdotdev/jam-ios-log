import Combine
import Foundation
import UIKit

extension UIApplication {
  fileprivate var firstKeyWindow: UIWindow? {
    connectedScenes.compactMap { $0 as? UIWindowScene }.first?.keyWindow
  }
}

@available(iOS 17, *)
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
  private var cancellable: AnyCancellable?

  private var reachability = Reachability.unreachable

  private init() {
    (stream, continuation) = AsyncStream.makeStream(of: LogMessage.self)

    let keyWindow = UIApplication.shared.firstKeyWindow

    let isCaptured: Bool =
      if #available(iOS 17.0, *) {
        keyWindow?.traitCollection.sceneCaptureState == .active
      } else {
        keyWindow?.screen.isCaptured == true
      }

    reachability = isCaptured ? .unknown(Date.now) : .unreachable

    if #available(iOS 17.0, *) {
      keyWindow?.registerForSceneCaptureStateChanges { [weak self] sceneCaptureState in
        self?.reachability = sceneCaptureState == .active ? .unknown(Date.now) : .unreachable
      }
    } else {
      cancellable = NotificationCenter.default.publisher(for: UIScreen.capturedDidChangeNotification)
        .sink { [weak self] notification in
          guard let screen = notification.object as? UIScreen else { return }
          guard UIApplication.shared.firstKeyWindow?.screen == screen else { return }

          self?.reachability = screen.isCaptured ? .unknown(Date.now) : .unreachable
        }
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
