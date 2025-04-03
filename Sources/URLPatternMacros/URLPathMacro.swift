import SwiftCompilerPlugin
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros
import Foundation

public struct URLPathMacro: PeerMacro {
  struct CaseParam: Hashable {
    let index: Int
    let name: String
  }
  
  struct PatternPathItem {
  
  }
  
  public static func expansion(
    of node: AttributeSyntax,
    providingPeersOf declaration: some DeclSyntaxProtocol,
    in context: some MacroExpansionContext
  ) throws -> [DeclSyntax] {
    guard
      let enumCase = declaration.as(EnumCaseDeclSyntax.self),
      let element = enumCase.elements.first
    else {
      throw MacroError.message("URLPatternPath macro can only be applied to enum cases")
    }

    guard
      let argument = node.arguments?.as(LabeledExprListSyntax.self)?.first,
      let pathString = argument.expression.as(StringLiteralExprSyntax.self)?.segments.first?.description
    else {
        throw MacroError.message("Invalid path")
    }
    
    guard let pathURL = URL(string: pathString) else {
      throw MacroError.message("URLPatternPath macro requires a string literal path")
    }
    
    let patternPaths = pathURL.pathComponents

    let pathComponents = pathURL.pathComponents
    let parameters = pathComponents.enumerated()
      .filter { index, value in value.isURLPathParam }
      .map { CaseParam(index: $0.offset, name: String($0.element.dropFirst().dropLast())) }
    
    if Set(parameters).count != parameters.count {
      throw MacroError.message("변수 이름은 중복되서는 안됩니다.")
    }

    let staticMethod = try FunctionDeclSyntax("""
      static func \(element.name)(_ url: URL) -> Self? {
          let inputPaths = url.pathComponents
          let patternPaths = \(raw: patternPaths)
      
          guard isValidURLPaths(inputPaths: inputPaths, patternPaths: patternPaths) else { return nil }
      
          \(raw: parameters.map { param in
          """
          let \(param.name) = inputPaths[\(param.index)] 
          """
          }.joined(separator: "\n"))
          
          return .\(raw: element.name.text)(\(raw: parameters.map { "\($0.name): \($0.name)" }.joined(separator: ", ")))
      }
      """
    )
    
    return [DeclSyntax(staticMethod)]
  }
}
