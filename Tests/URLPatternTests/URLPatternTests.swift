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
              case name(id: String, name: String)
          }
          """,
          expandedSource: """
          enum Deeplink {
              case post(id: String)

              static func createFromURLpost(_ url: URL) -> Self? {
                  let path = url.path
                  let components = path.split(separator: "/")

                  guard components.count == 2 else {
                      return nil
                  }

                  guard let id = components[1] as? String else {
                      return nil
                  }

                  return .post(id: id)
              }

              case name(id: String, name: String)

              static func createFromURLname(_ url: URL) -> Self? {
                  let path = url.path
                  let components = path.split(separator: "/")

                  guard components.count == 3 else {
                      return nil
                  }

                  guard let id = components[1] as? String else {
                      return nil
                  }
                  guard let name = components[2] as? String else {
                      return nil
                  }

                  return .name(id: id, name: name)
              }

              init?(url: URL) {
                  if let result = Self.createFromURLpost(url) {
                                  self = result
                                  return
                  }
                  if let result = Self.createFromURLname(url) {
                                  self = result
                                  return
                  }
                  return nil
              }
          }
          """,
          macros: testMacros
      )
    }

    func testMacroWithStringLiteral() throws {

    }
}
