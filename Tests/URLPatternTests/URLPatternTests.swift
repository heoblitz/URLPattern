import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros
import SwiftSyntaxMacrosTestSupport
import XCTest

#if canImport(URLPatternMacros)
import URLPatternMacros

let testMacros: [String: Macro.Type] = [
  "URLPattern": URLPatternMacro.self,
  "URLPath": URLPathMacro.self
]
#endif

final class URLPatternTests: XCTestCase {
  func testDeepLinkMacro_normalCase() throws {
    assertMacroExpansion(
      """
      @URLPattern
      enum DeepLink: Equatable {
          @URLPath("/home")
          case home
        
          @URLPath("/posts/{postId}")
          case post(postId: String)
        
          @URLPath("/posts/{postId}/comments/{commentId}")
          case postComment(postId: String, commentId: String)
        
          @URLPath("/c/{cNum}/b/{bNum}/a/{aNum}")
          case complex(aNum: Int, bNum: Int, cNum: Int)
      }
      """,
      expandedSource: """
      enum DeepLink: Equatable {
          case home

          static func home(_ url: URL) -> Self? {
              let inputPaths = url.pathComponents
              let patternPaths = ["/", "home"]

              guard isValidURLPaths(inputPaths: inputPaths, patternPaths: patternPaths) else {
                  return nil
              }

              return .home
          }

          case post(postId: String)

          static func post(_ url: URL) -> Self? {
              let inputPaths = url.pathComponents
              let patternPaths = ["/", "posts", "{postId}"]

              guard isValidURLPaths(inputPaths: inputPaths, patternPaths: patternPaths) else {
                  return nil
              }
              let postId = inputPaths[2]
              return .post(postId: postId)
          }

          case postComment(postId: String, commentId: String)

          static func postComment(_ url: URL) -> Self? {
              let inputPaths = url.pathComponents
              let patternPaths = ["/", "posts", "{postId}", "comments", "{commentId}"]

              guard isValidURLPaths(inputPaths: inputPaths, patternPaths: patternPaths) else {
                  return nil
              }
              let postId = inputPaths[2]
              let commentId = inputPaths[4]
              return .postComment(postId: postId, commentId: commentId)
          }

          case complex(aNum: Int, bNum: Int, cNum: Int)

          static func complex(_ url: URL) -> Self? {
              let inputPaths = url.pathComponents
              let patternPaths = ["/", "c", "{cNum}", "b", "{bNum}", "a", "{aNum}"]

              guard isValidURLPaths(inputPaths: inputPaths, patternPaths: patternPaths) else {
                  return nil
              }
              guard let aNum = Int(inputPaths[6]) else {
                  return nil
              }
              guard let bNum = Int(inputPaths[4]) else {
                  return nil
              }
              guard let cNum = Int(inputPaths[2]) else {
                  return nil
              }
              return .complex(aNum: aNum, bNum: bNum, cNum: cNum)
          }

          init?(url: URL) {
              if let urlPattern = Self.home(url) {
                  self = urlPattern
                  return
              }
              if let urlPattern = Self.post(url) {
                  self = urlPattern
                  return
              }
              if let urlPattern = Self.postComment(url) {
                  self = urlPattern
                  return
              }
              if let urlPattern = Self.complex(url) {
                  self = urlPattern
                  return
              }
              return nil
          }

          static func isValidURLPaths(inputPaths inputs: [String], patternPaths patterns: [String]) -> Bool {
              guard inputs.count == patterns.count else {
                  return false
              }

              return zip(inputs, patterns).allSatisfy { input, pattern in
                  guard Self.isURLPathValue(pattern) else {
                      return input == pattern
                  }

                  return true
              }
          }

          static func isURLPathValue(_ string: String) -> Bool {
              return string.hasPrefix("{") && string.hasSuffix("}") && string.utf16.count >= 3
          }
      }
      """,
      macros: testMacros
    )
  }
  
  func testDeepLinkMacro_shouldIgnoreNoneMacroCase() throws {
    assertMacroExpansion(
      """
      @URLPattern
      enum DeepLink: Equatable {
          @URLPath("/home")
          case home
      
          case complex(aNum: Int, bNum: Int, cNum: Int)
      }
      """,
      expandedSource: """
      enum DeepLink: Equatable {
          case home

          static func home(_ url: URL) -> Self? {
              let inputPaths = url.pathComponents
              let patternPaths = ["/", "home"]

              guard isValidURLPaths(inputPaths: inputPaths, patternPaths: patternPaths) else {
                  return nil
              }

              return .home
          }

          case complex(aNum: Int, bNum: Int, cNum: Int)

          init?(url: URL) {
              if let urlPattern = Self.home(url) {
                  self = urlPattern
                  return
              }
              return nil
          }

          static func isValidURLPaths(inputPaths inputs: [String], patternPaths patterns: [String]) -> Bool {
              guard inputs.count == patterns.count else {
                  return false
              }

              return zip(inputs, patterns).allSatisfy { input, pattern in
                  guard Self.isURLPathValue(pattern) else {
                      return input == pattern
                  }

                  return true
              }
          }

          static func isURLPathValue(_ string: String) -> Bool {
              return string.hasPrefix("{") && string.hasSuffix("}") && string.utf16.count >= 3
          }
      }
      """,
      macros: testMacros
    )
  }
}
