import JamLog
import Logging
import UIKit

extension LogMessage.Level {
  init(_ level: Logger.Level) {
    self =
      switch level {
      case .trace, .debug: .debug
      case .info, .notice: .info
      case .warning: .warn
      case .error, .critical: .error
      }
  }
}

/// A log handler that sends logs to Jam.
public struct JamLogHandler: LogHandler {
  /// The log level.
  ///
  /// A `Logger.Level` is mapped to a `JamLog.LogMessage.Level` as follows:
  ///
  /// | `Logger.Level`        | `JamLog.LogMessage.Level` |
  /// |-----------------------|---------------------------|
  /// | `.trace`, `.debug`    | `.debug`                  |
  /// | `.info`, `.notice`    | `.info`                   |
  /// | `.warning`            | `.warn`                   |
  /// | `.error`, `.critical` | `.error`                  |
  public var logLevel = Logger.Level.info
  public var metadataProvider: Logger.MetadataProvider?

  private let label: String
  private var metadataFormatter = MetadataFormatter()

  public init(label: String) {
    self.label = label
  }

  public var metadata = Logger.Metadata() {
    didSet {
      metadataFormatter.loggerMetadata = metadata
    }
  }

  public subscript(metadataKey key: String) -> Logger.Metadata.Value? {
    get { metadata[key] }
    set { metadata[key] = newValue }
  }

  public func log(
    level: Logger.Level,
    message: Logger.Message,
    metadata: Logger.Metadata?,
    source: String,
    file: String,
    function: String,
    line: UInt
  ) {
    let formattedMetadata = metadataFormatter.string(metadataProvider: metadataProvider, messageMetadata: metadata)

    let label = label.isEmpty ? nil : label

    let message = [label, formattedMetadata.map { "[\($0)]" }, message.description].compactMap { $0 }
      .joined(separator: " ")

    JamLog.log(message, level: .init(level), file: file, function: function, line: line)
  }
}
