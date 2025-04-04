import Foundation

extension String {
  var isURLPathValue: Bool { self.hasPrefix("{") && self.hasSuffix("}") }
}
