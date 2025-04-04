import SwiftCompilerPlugin
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros
import Foundation

public struct URLPathMacro: PeerMacro {
  enum SupportedType: String {
    case String
    case Int
    case Double
    case Float
  }
  
  struct PatternParam: Hashable {
    let name: String
    let type: SupportedType
    let pathIndex: Int
    let caseIndex: Int
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
      throw URLPatternError("@URLPathMacro can only be applied to enum cases")
    }
    
    guard
      let argument = node.arguments?.as(LabeledExprListSyntax.self)?.first,
      let pathString = argument.expression.as(StringLiteralExprSyntax.self)?.segments.first?.description
    else {
      throw URLPatternError("URLPath is nil")
    }
    
    guard let pathURL = URL(string: pathString) else {
      throw URLPatternError("URLPath is not in a valid URL format")
    }
    
    let patternPaths = pathURL.pathComponents
    
    let caseAssociatedTypes = try element.parameterClause?.parameters.map { param -> (name: String, type: SupportedType) in
      let name = param.firstName?.text ?? ""
      let type = param.type.description
      
      guard let supportedType = SupportedType(rawValue: type) else {
        throw URLPatternError("\(type) is not supported as an associated value")
      }
      return (name: name, type: supportedType)
    } ?? []
    
    let patternParams: [PatternParam] = try patternPaths.enumerated()
      .filter { index, value in value.isURLPathValue }
      .map { pathIndex, value -> PatternParam in
        let name = String(value.dropFirst().dropLast())
        
        guard let (caseIndex, caseAssociatedType) = caseAssociatedTypes.enumerated().first(where: { name == $0.element.name }) else {
          throw URLPatternError("URLPath value \"\(name)\" cannot be found in the associated value")
        }
        
        return PatternParam(
          name: name,
          type: caseAssociatedType.type,
          pathIndex: pathIndex,
          caseIndex: caseIndex
        )
      }
      .sorted(by: { $0.caseIndex < $1.caseIndex })
    
    let patternNames = Set(patternParams.map(\.name))
    let caseNames = Set(caseAssociatedTypes.map(\.name))

    guard patternNames.count == patternParams.count else {
      throw URLPatternError("The name of an URLPath value cannot be duplicated")
    }
    
    guard caseNames.count == caseAssociatedTypes.count else {
      throw URLPatternError("The name of an associated value cannot be duplicated")
    }
    
    guard patternNames.count == caseNames.count else {
      throw URLPatternError("The number of associated values does not match URLPath")
    }
    
    guard patternNames == caseNames else {
      throw URLPatternError("The name of the URLPath value does not match the associated value")
    }
    
    let staticMethod = try FunctionDeclSyntax("""
      static func \(element.name)(_ url: URL) -> Self? {
          let inputPaths = url.pathComponents
          let patternPaths = \(raw: patternPaths)
        
          guard isValidURLPaths(inputPaths: inputPaths, patternPaths: patternPaths) else { return nil }
          \(raw: patternParams.map { param in
          switch param.type {
            case .Double, .Float, .Int:
            """
            guard let \(param.name) = \(param.type.rawValue)(inputPaths[\(param.pathIndex)]) else { return nil }
            """
            case .String:
            """
            let \(param.name) = inputPaths[\(param.pathIndex)]
            """
            }
          }.joined(separator: "\n"))
          return \(raw: patternParams.isEmpty
          ? ".\(element.name.text)"
          : ".\(element.name.text)(\(patternParams.map { "\($0.name): \($0.name)" }.joined(separator: ", ")))")
      }
      """)
    
    return [DeclSyntax(staticMethod)]
  }
}
