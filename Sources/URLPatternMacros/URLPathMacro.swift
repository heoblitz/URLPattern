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
    
    let patternParams = patternPaths.enumerated()
      .filter { index, value in value.isURLPathParam }
      .map { index, value in
        let name = String(value.dropFirst().dropLast())
        return PatternParam(
          name:name ,
          type: caseAssociatedTypes.first(where: { name == $0.name })!.type,
          pathIndex: index
        )
      }
    
    if Set(patternParams.map { $0.name }).count != patternParams.count {
      throw URLPatternError("The name of an associated value cannot be duplicated")
    }
    
    if Set(patternParams).count != caseAssociatedTypes.count {
      throw URLPatternError("The number of associated values does not match URLPath")
    }
    
    let staticMethod = try FunctionDeclSyntax("""
      static func \(element.name)(_ url: URL) -> Self? {
        let inputPaths = url.pathComponents
        let patternPaths = \(raw: patternPaths)
      
        guard isValidURLPaths(inputPaths: inputPaths, patternPaths: patternPaths) else {
          return nil
        }
                
        \(raw: patternParams.map { param in
          switch param.type {
            case .Double:
            """
            guard let \(param.name) = \(param.type.rawValue)(inputPaths[\(param.pathIndex)]) else {
              return nil
            }
            """
            case .Float:
            """
            guard let \(param.name) = \(param.type.rawValue)(inputPaths[\(param.pathIndex)]) else {
              return nil
            }
            """
            case .Int:
            """
            guard let \(param.name) = \(param.type.rawValue)(inputPaths[\(param.pathIndex)]) else {
              return nil
            }
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
