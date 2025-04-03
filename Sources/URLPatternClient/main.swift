import URLPattern
import Foundation

@URLPattern
enum Deeplink {
  @URLPath("/post/{id}/{name}")
  case name(id: Int, name: String)
  
  @URLPath("/post/{id}/{name}/hi/{good}")
  case nameDetail(id: String, name: String, good: String)
  
  @URLPath("/post/{id}")
  case nameDetailHI(id: String)
  
  @URLPath("/home")
  case home
}

let url1 = URL(string: "https://channel.io/post/12/12")
let url2 = URL(string: "/post/hi/hello/hi/bye")
let url3 = URL(string: "/home")

// enumPath
// inputPath


print(url1?.pathComponents)
print(url2?.pathComponents)


let hi = URL(string: "https://post/{id}")
let paths = url1!.pathComponents

print(Deeplink(url: url1!))
print(Deeplink(url: url2!))
print(Deeplink(url: url3!))

