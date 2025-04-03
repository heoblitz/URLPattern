//
//  URLPatternExampleTests.swift
//  URLPatternExampleTests
//
//  Created by woody on 4/3/25.
//

import Testing
import Foundation
@testable import URLPatternExample

struct URLPatternExampleTests {
  @Test func testSingleValue() async throws {
    let url = try #require(URL(string: "https://www.example.com/home"))
    let deepLink = try #require(DeepLink(url: url))
    #expect(deepLink == .home)
  }
  
  @Test func testWrongPathSingleValue() async throws {
    let url = try #require(URL(string: "https://www.example.com/homes"))
    let deepLink = DeepLink(url: url)
    #expect(deepLink == nil)
  }
  
  @Test func testWrongManyPathSingleValue() async throws {
    let url = try #require(URL(string: "https://www.example.com/home/path"))
    let deepLink = DeepLink(url: url)
    #expect(deepLink == nil)
  }
}
