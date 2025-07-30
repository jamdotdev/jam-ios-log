public struct LogMessage: Codable, Sendable {
  public struct Trace: Hashable, Codable, CustomStringConvertible, Sendable {
    public let file: String
    public let function: String
    public let line: UInt

    public init(file: String, function: String, line: UInt) {
      self.file = file
      self.function = function
      self.line = line
    }

    public var description: String {
      "\(file).\(function):\(line)"
    }
  }

  public enum Level: String, CaseIterable, Hashable, Codable, Sendable {
    case debug, info, warn, error
  }

  public let level: Level
  public let message: String
  public let trace: Trace

  public init(level: Level, message: String, trace: Trace) {
    self.level = level
    self.message = message
    self.trace = trace
  }
}
