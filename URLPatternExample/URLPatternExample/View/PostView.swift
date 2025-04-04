//
//  PostView.swift
//  URLPatternExample
//
//  Created by woody on 4/4/25.
//

import SwiftUI

struct PostView: View {
  let postId: String
  
  var body: some View {
    Text("📮 postId: \(postId)")
      .font(.largeTitle)
      .navigationTitle("Post")
  }
}
