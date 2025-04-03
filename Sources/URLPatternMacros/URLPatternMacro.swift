import SwiftCompilerPlugin
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros
import Foundation

public struct URLPatternMacro: MemberMacro {
  public static func expansion(
    of node: AttributeSyntax,
    providingMembersOf declaration: some DeclGroupSyntax,
    in context: some MacroExpansionContext
  ) throws -> [DeclSyntax] {
    guard let enumDecl = declaration.as(EnumDeclSyntax.self) else {
      throw URLPatternError("@URLPatternMacro can only be applied to enums")
    }
    
    let urlInitializer = try InitializerDeclSyntax("init?(url: URL)") {
      for caseDecl in enumDecl.memberBlock.members.compactMap({ $0.decl.as(EnumCaseDeclSyntax.self) }) {
        if let caseName = caseDecl.elements.first?.name.text {
          """
          if let urlPattern = Self.\(raw: caseName)(url) {
            self = urlPattern
            return
          }
          """
        }
      }
      
      """
      return nil
      """
    }
    
    let isValidURLPathsMethod = try FunctionDeclSyntax("""
      static func isValidURLPaths(inputPaths inputs: [String], patternPaths patterns: [String]) -> Bool {
        guard inputs.count == patterns.count else { return false }
        
        return zip(inputs, patterns).allSatisfy { input, pattern in
          guard Self.isURLPathParam(pattern) else { return input == pattern }
          
          return true
        }
      }
      """)
    
    let isURLPathParamMethod = try FunctionDeclSyntax("""
      static func isURLPathParam(_ string: String) -> Bool {
        return string.hasPrefix("{") && string.hasSuffix("}")
      }
      """)
    
    return [
      DeclSyntax(urlInitializer),
      DeclSyntax(isValidURLPathsMethod),
      DeclSyntax(isURLPathParamMethod)
    ]
  }
}
