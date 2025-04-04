//
//  DeepLinkMock.swift
//  URLPatternExample
//
//  Created by woody on 4/4/25.
//

import URLPattern

@URLPattern
enum DeepLinkMock: Equatable {
  @URLPath("/home")
  case home
  
  @URLPath("/posts/{postId}")
  case post(postId: String)
  
  @URLPath("/posts/{postId}/comments/{commentId}")
  case postComment(postId: String, commentId: String)
  
  @URLPath("/setting/{number}")
  case setting(number: Int)
  
  @URLPath("/int/{int}")
  case int(int: Int)
  
  @URLPath("/float/{float}")
  case float(float: Float)
  
  @URLPath("/string/{string}")
  case string(string: String)
  
  @URLPath("/c/{cNum}/b/{bNum}/a/{aNum}")
  case complex(aNum: Int, bNum: Int, cNum: Int)
}
