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
    
    let cases = enumDecl.memberBlock.members.compactMap { member -> String? in
      guard
        let caseDecl = member.decl.as(EnumCaseDeclSyntax.self),
        caseDecl.attributes.contains(where: {
          $0.as(AttributeSyntax.self)?.attributeName.as(IdentifierTypeSyntax.self)?.name.text == "URLPath"
        })
      else {
        return nil
      }
      
      return caseDecl.elements.first?.name.text
    }
    
    guard Set(cases).count == cases.count else {
      throw URLPatternError("Duplicate case names are not allowed")
    }
    
    let urlInitializer = try InitializerDeclSyntax("init?(url: URL)") {
      for caseName in cases {
        """
        if let urlPattern = Self.\(raw: caseName)(url) {
            self = urlPattern
            return
        }
        """
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
