//
//  RootView.swift
//  URLPatternExample
//
//  Created by woody on 4/3/25.
//

import SwiftUI

struct RootView: View {
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
        Section("Invalid DeepLink") {
          Text("https://home")
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
      .navigationDestination(for: Route.self) { route in
        route
      }
    }
  }
}

#Preview {
  RootView()
}
