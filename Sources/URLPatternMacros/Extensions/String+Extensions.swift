import Foundation

extension String {
  var isURLPathValue: Bool { self.hasPrefix("{") && self.hasSuffix("}") && self.utf16.count >= 3 }
}
