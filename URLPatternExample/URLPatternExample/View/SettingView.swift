//
//  SettingView.swift
//  URLPatternExample
//
//  Created by woody on 4/4/25.
//

import SwiftUI

struct SettingView: View {
  let number: Int
  
  var body: some View {
    Text("⚙️ number: \(number)")
      .font(.largeTitle)
      .navigationTitle("Setting")
  }
}
