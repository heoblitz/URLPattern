import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros
import SwiftSyntaxMacrosTestSupport
import XCTest

// Macro implementations build for the host, so the corresponding module is not available when cross-compiling. Cross-compiled tests may still make use of the macro itself in end-to-end tests.
#if canImport(URLPatternMacros)
import URLPatternMacros

let testMacros: [String: Macro.Type] = [
    "URLPattern": URLPatternMacro.self,
    "URLPath": URLPathMacro.self
]
#endif

final class URLPatternTests: XCTestCase {
    func testMacro() throws {
      assertMacroExpansion(
          """
          @URLPattern
          enum Deeplink {
              @URLPath("/post/{id}")
              case post(id: String)
              
              @URLPath("/post/{id}/{name}")
              case name(id: String, name: Int)
          }
          """,
          expandedSource: """
          enum Deeplink {
              case post(id: String)

              static func post(_ url: URL) -> Self? {
                  let inputPaths = url.pathComponents
                  let patternPaths = ["/", "post", "{id}"]

                  guard isValidURLPaths(inputPaths: inputPaths, patternPaths: patternPaths) else {
                      return nil
                  }

                  let id = inputPaths[2]

                  return .post(id: id)
              }

              case name(id: String, name: String)

              static func name(_ url: URL) -> Self? {
                  let inputPaths = url.pathComponents
                  let patternPaths = ["/", "post", "{id}", "{name}"]

                  guard isValidURLPaths(inputPaths: inputPaths, patternPaths: patternPaths) else {
                      return nil
                  }

                  let id = inputPaths[2]
                  let name = inputPaths[3]

                  return .name(id: id, name: name)
              }

              init?(url: URL) {
                  if let result = Self.post(url) {
                      self = result
                      return
                  }
                  if let result = Self.name(url) {
                      self = result
                      return
                  }
                  return nil
              }

              static func isValidURLPaths(inputPaths inputs: [String], patternPaths patterns: [String]) -> Bool {
                guard inputs.count == patterns.count else {
                    return false
                }

                return zip(inputs, patterns).allSatisfy { input, pattern in
                  guard pattern.isURLPathParam else {
                      return input == pattern
                  }

                  return true
                }
              }

              static func isURLPathParam(_ string: String) -> Bool {
                return string.hasPrefix("{") && string.hasSuffix("}")
              }
          }
          """,
          macros: testMacros
      )
    }

    func testMacroWithStringLiteral() throws {

    }
}
