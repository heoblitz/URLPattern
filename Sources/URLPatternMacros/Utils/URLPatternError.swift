import Foundation

struct URLPatternError: LocalizedError {
  let errorDescription: String
  
  init(_ errorDescription: String) {
    self.errorDescription = errorDescription
  }
}

extension URLPatternError: CustomStringConvertible {
  var description: String { self.errorDescription }
}
