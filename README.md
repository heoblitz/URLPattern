# URLPattern
[![Swift](https://github.com/heoblitz/URLPattern/actions/workflows/swift.yml/badge.svg?branch=main)](https://github.com/heoblitz/URLPattern/actions/workflows/swift.yml)

A Swift Macro that helps mapping URLs to Enum cases.

## Overview

URL deep linking is a fundamental technology widely used in most services today. However, in Swift environments, implementing deep linking typically requires direct URL path manipulation or regex usage:

```swift
// Traditional approach with manual URL handling
let paths = url.pathComponents

if paths.count == 2 && paths[1] == "home" {
  // Handle home
} else let match = try? url.path.firstMatch(of: /\/posts\/([^\/]+)$/) {
  // Handle posts
}
```

This approach reduces code readability and scalability, and importantly, cannot validate incorrect patterns at compile-time.

URLPattern solves these issues by providing compile-time URL validation and value mapping:

```swift
@URLPattern
enum DeepLink {
  @URLPath("/home")
  case home
    
  @URLPath("/posts/{postId}")
  case post(postId: String)
    
  @URLPath("/posts/{postId}/comments/{commentId}")
  case postComment(postId: String, commentId: String)
}
```

## Features

- **Compile-time Validation**: Ensures URL path values and associated value names match correctly
- **Automatic Enum Generation**: Creates initializers that map URL components to enum associated values
- **Type Support**: 
  - Built-in support for `String`, `Int`, `Float`, and `Double`
  - Non-String types (Int, Float, Double) use String-based initialization

## Usage

```swift
@URLPattern
enum DeepLink {
  @URLPath("/posts/{postId}")
  case post(postId: String)

  @URLPath("/posts/{postId}/comments/{commentId}")
  case postComment(postId: String, commentId: String)

  @URLPath("/f/{first}/s/{second}")
  case reverse(second: Int, first: Int)
}
```

1. Declare the `@URLPattern` macro on your enum.

2. Add `@URLPath` macro to enum cases with the desired URL pattern.

3. Use path values with `{associated_value_name}` syntax to map URL components to associated value names. If mapping code is duplicated, the topmost enum case takes precedence.


```swift
// ✅ Valid URLs
DeepLink(url: URL(string: "/posts/1")!) == .post(postId: "1")
DeepLink(url: URL(string: "/posts/1/comments/2")!) == .postComment(postId: "1", commentId: "2")
DeepLink(url: URL(string: "/f/1/s/2")!) == .postComment(second: 2, first: 1)

// ❌ Invalid URLs
DeepLink(url: URL(string: "/post/1")) == nil
DeepLink(url: URL(string: "/posts/1/comments")) == nil
DeepLink(url: URL(string: "/f/string/s/string")!) == nil
```
4. Use the `Enum.init(url: URL)` generated initializer. 
```
if let deepLink = DeepLink(url: incomingURL) {
  switch deepLink {
  case .post(let postId):
    // Handle post
  case .postComment(let postId, let commentId):
    // Handle postComment
  }
}
```
5. Implement a deep link using an enum switch statement.
- For more detailed examples, please refer to the [Example project](https://github.com/heoblitz/URLPattern/tree/feature/main/URLPatternExample).

## Rules

- **Unique Enum Case Names**: Enum case names must be unique for better readability of expanded macro code.
- **Unique Associated Value Names**: Associated value names within each case must be unique.
- **Valid URL Patterns**: Arguments passed to @URLPath macro must be in valid URL path format.
- **Supported Types**: Only String, Int, Float, and Double are supported.

## Installation
### Swift Package Manager
Project > Project Dependencies > Add &nbsp; `https://github.com/heoblitz/URLPattern.git`  
