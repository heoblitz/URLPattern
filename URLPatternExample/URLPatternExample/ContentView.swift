//
//  ContentView.swift
//  URLPatternExample
//
//  Created by woody on 4/3/25.
//

import SwiftUI
import URLPattern

@URLPattern
enum DeepLink: Equatable {
  @URLPath("/home")
  case home
  
  @URLPath("/posts/{postId}")
  case post(postId: String)
  
  @URLPath("/posts/{postId}/comments/{commentId}")
  case postComment(postId: String, commentId: String)
  
  @URLPath("/setting/{number}")
  case setting(number: Int)
}

enum Route: Hashable {
  case home
  case post(postId: String)
  case comment(commentId: String)
  case setting(number: Int)
}

struct ContentView: View {
  @State private var path = NavigationPath()
  
  var body: some View {
    NavigationStack(path: $path) {
      List {
        Section("DeepLink Example") {
          Text("https://domain/home")
          Text("https://domain/posts/1")
          Text("https://domain/posts/1/comments/2")
          Text("https://domain/setting/1")
        }
        Section("Wrong DeepLink Example") {
          Text("https://domain/homes")
          Text("https://domain/post/1")
          Text("https://domain/setting/string")
        }
      }
      .navigationTitle("URLPattern Example")
      .environment(\.openURL, OpenURLAction { url in
        guard let deepLink = DeepLink(url: url) else {
          return .discarded
        }
        
        switch deepLink {
        case .home:
          path.append(Route.home)
        case .post(let postId):
          path.append(Route.post(postId: postId))
        case .postComment(let postId, let commentId):
          path.append(Route.post(postId: postId))
          path.append(Route.comment(commentId: commentId))
        case .setting(let number):
          path.append(Route.setting(number: number))
        }
        return .handled
      })
      .navigationDestination(for: Route.self) { deepLink in
        switch deepLink {
        case .home:
          Home()
        case .post(let postId):
          Post(postId: postId)
        case .comment(let commentId):
          Comment(commentId: commentId)
        case .setting(let number):
          Setting(number: number)
        }
      }
    }
  }
}

struct Home: View {
  var body: some View {
    Text("🏠")
      .font(.largeTitle)
      .navigationTitle("Home")
  }
}

struct Post: View {
  let postId: String
  
  var body: some View {
    Text("📮 postId: \(postId)")
      .font(.largeTitle)
      .navigationTitle("Post")
  }
}

struct Comment: View {
  let commentId: String
  
  var body: some View {
    Text("💬 commentId: \(commentId)")
      .font(.largeTitle)
      .navigationTitle("Comment")
  }
}

struct Setting: View {
  let number: Int
  
  var body: some View {
    Text("⚙️ number: \(number)")
      .font(.largeTitle)
      .navigationTitle("Setting")
  }
}

#Preview {
  ContentView()
}
