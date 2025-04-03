import SwiftCompilerPlugin
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros
import Foundation

@main
struct URLPatternPlugin: CompilerPlugin {
  let providingMacros: [Macro.Type] = [URLPatternMacro.self, URLPathMacro.self]
}
