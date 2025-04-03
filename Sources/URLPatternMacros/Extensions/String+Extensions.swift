import Foundation

extension String {
  var isURLPathParam: Bool { self.hasPrefix("{") && self.hasSuffix("}") }
}
