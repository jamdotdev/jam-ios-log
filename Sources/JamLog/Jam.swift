import Foundation

public enum JamLog {
  public static func debug(
    _ message: String,
    file: String = #fileID,
    function: String = #function,
    line: UInt = #line
  ) {
    log(message, level: .debug, file: file, function: function, line: line)
  }

  public static func info(_ message: String, file: String = #fileID, function: String = #function, line: UInt = #line) {
    log(message, level: .info, file: file, function: function, line: line)
  }

  public static func warn(_ message: String, file: String = #fileID, function: String = #function, line: UInt = #line) {
    log(message, level: .warn, file: file, function: function, line: line)
  }

  public static func error(
    _ message: String,
    file: String = #fileID,
    function: String = #function,
    line: UInt = #line
  ) {
    log(message, level: .error, file: file, function: function, line: line)
  }

  private static func log(_ message: String, level: LogMessage.Level, file: String, function: String, line: UInt) {
    Task.detached {
      let logMessage = LogMessage(
        level: level,
        message: message,
        trace: .init(file: file, function: function, line: line)
      )

      await Logger.shared.log(logMessage)
    }
  }
}
