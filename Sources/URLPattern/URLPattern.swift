@_exported import Foundation

@attached(member, names: arbitrary)
public macro URLPattern() = #externalMacro(module: "URLPatternMacros", type: "URLPatternMacro")

@attached(peer, names: arbitrary)
public macro URLPath(_ path: String) = #externalMacro(module: "URLPatternMacros", type: "URLPathMacro")
