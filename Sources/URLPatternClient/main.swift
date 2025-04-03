import URLPattern
import Foundation

@URLPattern
enum Deeplink {
//  @URLPath("/post/{id}")
//  case post(id: String)
//  
  @URLPath("/home/{id}/{name}")
  case name(id: String, name: String)
  
  @URLPath("/post/{id}/{name}/hi/{good}")
  case nameDetail(id: String, name: String, good: String)
  
  @URLPath("/post/{id}")
  case nameDetailHI(id: String)
}

let url1 = URL(string: "https://channel.io/post/12/12")
let url2 = URL(string: "/post/hi/hello/hi/bye")

// enumPath
// inputPath


print(url1?.pathComponents)
print(url2?.pathComponents)


let hi = URL(string: "https://post/{id}")
let paths = url1!.pathComponents

print(Deeplink(url: url1!))
print(Deeplink(url: url2!))

