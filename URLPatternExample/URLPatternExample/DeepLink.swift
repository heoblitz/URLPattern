//
//  DeepLink.swift
//  URLPatternExample
//
//  Created by woody on 4/4/25.
//

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
