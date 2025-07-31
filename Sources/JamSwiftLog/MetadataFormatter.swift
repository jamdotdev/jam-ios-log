import Logging

struct MetadataFormatter {
  private var formattedLoggerMetadata: String?

  var loggerMetadata = Logger.Metadata() {
    didSet {
      guard !loggerMetadata.isEmpty else {
        formattedLoggerMetadata = nil
        return
      }

      formattedLoggerMetadata = string(for: loggerMetadata)
    }
  }

  func string(metadataProvider: Logger.MetadataProvider?, messageMetadata: Logger.Metadata?) -> String? {
    let providerMetadata = metadataProvider?.get() ?? [:]
    let messageMetadata = messageMetadata ?? [:]

    guard !providerMetadata.isEmpty || !messageMetadata.isEmpty else {
      return formattedLoggerMetadata
    }

    var metadata = loggerMetadata

    metadata.merge(providerMetadata) { $1 }
    metadata.merge(messageMetadata) { $1 }

    return string(for: metadata)
  }

  private func string(for metadata: Logger.Metadata) -> String? {
    guard !metadata.isEmpty else { return nil }

    return metadata
      .sorted { lhs, rhs in lhs.key < rhs.key }
      .map { key, value in "\(key): \(value)" }
      .joined(separator: ", ")
  }
}
