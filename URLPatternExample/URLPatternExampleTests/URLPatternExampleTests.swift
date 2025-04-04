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
  
  @URLPath("/setting/phone/{number}")
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
    "https://domain.com/setting/phone/42",
    "/setting/phone/42"
  ])
  func parseSetting_success(urlString: String) async throws {
    let url = try #require(URL(string: urlString))
    let deepLink = try #require(DeepLinkMock(url: url))
    #expect(deepLink == .setting(number: 42))
  }
  
  @Test("Invalid Setting URLPatterns", arguments: [
    "https://domain.com/setting/abc/42",
    "/setting/phone/12.34",
    "/setting/phone"
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
  
  // MARK: - Unicode Tests
  @Test("Valid Unicodes", arguments: [
    "안녕하세요",
    "こんにちは",
    "☺️👍"
  ])
  func paresPost_success_with_unicode(value: String) async throws {
    let url = try #require(URL(string: "/posts/\(value)"))
    let deepLink = DeepLinkMock(url: url)
    #expect(deepLink == .post(postId: value))
  }
  
  // MARK: - Unicode Tests
  @URLPattern
  enum PriorityTest: Equatable {
    @URLPath("/{a}/{b}")
    case all(a: String, b: String)
    
    @URLPath("/post/{postId}")
    case post(postId: Int)
  }
  
  @Test func checkPriorityCases() async throws {
    let url = try #require(URL(string: "/post/1"))
    #expect(PriorityTest(url: url) == .all(a: "post", b: "1"))
  }
  
  @URLPattern
  enum ScopeTest {
    @URLPath("/")
    case zero
    
    @URLPath("/{a}")
    case one(a: String)
    
    @URLPath("/{a}/{b}")
    case two(a: String, b: String)
    
    @URLPath("/{a}/{b}/{c}")
    case three(a: String, b: String, c: String)
    
    @URLPath("/{a}/{b}/{c}/{d}")
    case four(a: String, b: String, c: String, d: String)
    
    @URLPath("/{a}/{b}/{c}/{d}/{e}")
    case five(a: String, b: String, c: String, d: String, e: String)
    
    @URLPath("/{a}/{b}/{c}/{d}/{e}/{f}")
    case six(a: String, b: String, c: String, d: String, e: String, f: String)
    
    @URLPath("/{a}/{b}/{c}/{d}/{e}/{f}/{g}")
    case seven(a: String, b: String, c: String, d: String, e: String, f: String, g: String)
    
    @URLPath("/{a}/{b}/{c}/{d}/{e}/{f}/{g}/{h}")
    case eight(a: String, b: String, c: String, d: String, e: String, f: String, g: String, h: String)
    
    @URLPath("/{a}/{b}/{c}/{d}/{e}/{f}/{g}/{h}/{i}")
    case nine(a: String, b: String, c: String, d: String, e: String, f: String, g: String, h: String, i: String)
    
    @URLPath("/{a}/{b}/{c}/{d}/{e}/{f}/{g}/{h}/{i}/{j}")
    case ten(a: String, b: String, c: String, d: String, e: String, f: String, g: String, h: String, i: String, j: String)
  }
  @Test("Test scope", arguments: Array(0...20))
  func checkScope(num: Int) async throws {
    let url = try #require(URL(string: "/" + (0..<num).map { String($0) }.joined(separator: "/")))
    
    if num > 10 {
      #expect(ScopeTest(url: url) == nil)
    } else {
      #expect(ScopeTest(url: url) != nil)
    }
  }
}
