//
//  Route.swift
//  URLPatternExample
//
//  Created by woody on 4/4/25.
//

import SwiftUI

enum Route: Hashable, View {
  case home
  case post(postId: String)
  case comment(commentId: String)
  case setting(number: Int)
  
  var body: some View {
    switch self {
    case .home:
      HomeView()
    case .post(let postId):
      PostView(postId: postId)
    case .comment(let commentId):
      CommentView(commentId: commentId)
    case .setting(let number):
      SettingView(number: number)
    }
  }
}
