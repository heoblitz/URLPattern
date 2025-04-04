//
//  URLPatternExampleTests.swift
//  URLPatternExampleTests
//
//  Created by woody on 4/3/25.
//

import Testing
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

struct URLPatternExampleTests {
  // MARK: - Home Tests
  @Test("Valid Home URLPatterns", arguments: [
    "https://domain.com/home",
    "/home"
  ])
  func parseHome_success(urlString: String) async throws {
    let url = try #require(URL(string: urlString))
    let deepLink = try #require(DeepLinkMock(url: url))
    #expect(deepLink == .home)
  }
  
  @Test("Invalid Home URLPatterns", arguments: [
    "https://domain.com/home/12",
    "https://home",
    "home"
  ])
  func parseHome_failure(urlString: String) async throws {
    let url = try #require(URL(string: urlString))
    let deepLink = DeepLinkMock(url: url)
    #expect(deepLink == nil)
  }
  
  // MARK: - Post Tests
  @Test("Valid Post URLPatterns", arguments: [
    "https://domain.com/posts/1",
    "/posts/1"
  ])
  func parsePost_success(urlString: String) async throws {
    let url = try #require(URL(string: urlString))
    let deepLink = try #require(DeepLinkMock(url: url))
    #expect(deepLink == .post(postId: "1"))
  }
  
  @Test("Invalid Post URLPatterns", arguments: [
    "https://domain.com/posts/1/test",
    "https://domain.com/post/1",
    "/post/1"
  ])
  func parsePost_failure(urlString: String) async throws {
    let url = try #require(URL(string: urlString))
    let deepLink = DeepLinkMock(url: url)
    #expect(deepLink == nil)
  }
  
  // MARK: - Post Comment Tests
  @Test("Valid PostComment URLPatterns", arguments: [
    "https://domain.com/posts/1/comments/2",
    "/posts/1/comments/2"
  ])
  func parsePostComment_success(urlString: String) async throws {
    let url = try #require(URL(string: urlString))
    let deepLink = try #require(DeepLinkMock(url: url))
    #expect(deepLink == .postComment(postId: "1", commentId: "2"))
  }
  
  @Test("Invalid PostComment URLPatterns", arguments: [
    "https://domain.com/posts/1/comment/2",
    "/posts/1/comments",
    "/posts/comments/2"
  ])
  func parsePostComment_failure(urlString: String) async throws {
    let url = try #require(URL(string: urlString))
    let deepLink = DeepLinkMock(url: url)
    #expect(deepLink == nil)
  }
  
  // MARK: - Setting Tests
  @Test("Valid Setting URLPatterns", arguments: [
    "https://domain.com/setting/42",
    "/setting/42"
  ])
  func parseSetting_success(urlString: String) async throws {
    let url = try #require(URL(string: urlString))
    let deepLink = try #require(DeepLinkMock(url: url))
    #expect(deepLink == .setting(number: 42))
  }
  
  @Test("Invalid Setting URLPatterns", arguments: [
    "https://domain.com/setting/abc",
    "/setting/12.34",
    "/setting/"
  ])
  func parseSetting_failure(urlString: String) async throws {
    let url = try #require(URL(string: urlString))
    let deepLink = DeepLinkMock(url: url)
    #expect(deepLink == nil)
  }
  
  // MARK: - Int Tests
  @Test("Valid Int URLPatterns", arguments: [
    "https://domain.com/int/-42",
    "/int/-42"
  ])
  func parseInt_success(urlString: String) async throws {
    let url = try #require(URL(string: urlString))
    let deepLink = try #require(DeepLinkMock(url: url))
    #expect(deepLink == .int(int: -42))
  }
  
  @Test("Invalid Int URLPatterns", arguments: [
    "https://domain.com/int/abc",
    "/int/12.34",
    "/int/"
  ])
  func parseInt_failure(urlString: String) async throws {
    let url = try #require(URL(string: urlString))
    let deepLink = DeepLinkMock(url: url)
    #expect(deepLink == nil)
  }
  
  // MARK: - Float Tests
  @Test("Valid Float URLPatterns", arguments: [
    "https://domain.com/float/42.5",
    "/float/42.5"
  ])
  func parseFloat_success(urlString: String) async throws {
    let url = try #require(URL(string: urlString))
    let deepLink = try #require(DeepLinkMock(url: url))
    #expect(deepLink == .float(float: 42.5))
  }
  
  @Test("Invalid Float URLPatterns", arguments: [
    "https://domain.com/float/abc",
    "/float/",
    "/float/."
  ])
  func parseFloat_failure(urlString: String) async throws {
    let url = try #require(URL(string: urlString))
    let deepLink = DeepLinkMock(url: url)
    #expect(deepLink == nil)
  }
  
  // MARK: - String Tests
  @Test("Valid String URLPatterns", arguments: [
    "https://domain.com/string/hello",
    "/string/hello"
  ])
  func parseString_success(urlString: String) async throws {
    let url = try #require(URL(string: urlString))
    let deepLink = try #require(DeepLinkMock(url: url))
    #expect(deepLink == .string(string: "hello"))
  }
  
  @Test("Invalid String URLPatterns", arguments: [
    "https://domain.com/string",
    "/string/",
    "/string/test/extra"
  ])
  func parseString_failure(urlString: String) async throws {
    let url = try #require(URL(string: urlString))
    let deepLink = DeepLinkMock(url: url)
    #expect(deepLink == nil)
  }
  
  // MARK: - Complex Tests
  @Test("Valid Complex URLPatterns", arguments: [
    "https://domain.com/c/1/b/2/a/3",
    "/c/1/b/2/a/3"
  ])
  func parseComplex_success(urlString: String) async throws {
    let url = try #require(URL(string: urlString))
    let deepLink = try #require(DeepLinkMock(url: url))
    #expect(deepLink == .complex(aNum: 3, bNum: 2, cNum: 1))
  }
  
  @Test("Invalid Complex URLPatterns", arguments: [
    "https://domain.com/c/1/b/2/a/abc",
    "/c/1/b/abc/a/3",
    "/c/abc/b/2/a/3",
    "/c/1/b/2/a",
    "/c/1/b/a/3",
    "/a/1/b/2/c/3"
  ])
  func parseComplex_failure(urlString: String) async throws {
    let url = try #require(URL(string: urlString))
    let deepLink = DeepLinkMock(url: url)
    #expect(deepLink == nil)
  }
}
