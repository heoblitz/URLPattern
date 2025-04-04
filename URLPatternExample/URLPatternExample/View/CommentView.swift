//
//  CommentView.swift
//  URLPatternExample
//
//  Created by woody on 4/4/25.
//

import SwiftUI

struct CommentView: View {
  let commentId: String
  
  var body: some View {
    Text("💬 commentId: \(commentId)")
      .font(.largeTitle)
      .navigationTitle("Comment")
  }
}
