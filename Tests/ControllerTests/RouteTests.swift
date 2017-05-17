/**
* Copyright IBM Corporation 2017
*
* Licensed under the Apache License, Version 2.0 (the "License");
* you may not use this file except in compliance with the License.
* You may obtain a copy of the License at
*
* http://www.apache.org/licenses/LICENSE-2.0
*
* Unless required by applicable law or agreed to in writing, software
* distributed under the License is distributed on an "AS IS" BASIS,
* WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
* See the License for the specific language governing permissions and
* limitations under the License.
**/

#if os(Linux)
import Glibc
#else
import Darwin
#endif

import Foundation
import Kitura
import KituraNet
import XCTest
import Dispatch
import HeliumLogger
import SwiftyJSON

//import KituraStarterRouter
@testable import Controller

class RouteTests: XCTestCase {

  static var allTests : [(String, (RouteTests) -> () throws -> Void)] {
    return [
      ("testGetStatic", testGetStatic),
      ("testGetHello", testGetHello),
      ("testPostHello", testPostHello),
      ("testGetJSON", testGetJSON)
    ]
  }

  private let controller = Controller()
  private let queue = DispatchQueue(label: "Kitura runloop", qos: .userInitiated, attributes: .concurrent)

  override func setUp() {
    super.setUp()
    HeliumLogger.use()
    Kitura.addHTTPServer(onPort: 8080, with: controller.router)

    queue.async {
      Kitura.start()
    }

    print("------------------------------")
    print("------------New Test----------")
    print("------------------------------")
  }

  override func tearDown() {
    Kitura.stop()
    super.tearDown()
  }

  func testGetStatic() {

    let printExpectation = expectation(description: "The /route will serve static HTML content.")

    URLRequest(forTestWithMethod: "GET")?
    .sendForTestingWithKitura { data in
      if let getResult = String(data: data, encoding: String.Encoding.utf8){
        print("GET to / endpoint returned: ", getResult)
        XCTAssertTrue(getResult.contains("<h1 class=\"titleText\">IBM Kitura Starter Bluemix</h1>"))
      } else {
        XCTFail("Return value from / was nil!")
      }

      printExpectation.fulfill()
    }

    waitForExpectations(timeout: 10.0, handler: nil)
  }

  func testGetHello() {

    let printExpectation = expectation(description: "The /hello endpoint will return a String to the GET request.")

    URLRequest(forTestWithMethod: "GET", route: "hello")?
    .sendForTestingWithKitura { data in
      if let getResult = String(data: data, encoding: String.Encoding.utf8) {
        print("GET to /hello endpoint returned: ", getResult)
        XCTAssertTrue(getResult.contains("Hello from swift-evolution-backend!"))
      } else {
        XCTFail("Return value from /hello GET was nil!")
      }

      printExpectation.fulfill()
    }

    waitForExpectations(timeout: 10.0, handler: nil)
  }

  func testPostHello() {

    let printExpectation = expectation(description: "The /hello endpoint will return a String containing the data sent in the POST body.")

    URLRequest(forTestWithMethod: "POST", route: "hello", body: "from the other side".data(using: .utf8))?
    .sendForTestingWithKitura { data in
      if let postResult = String(data: data, encoding: String.Encoding.utf8){
        print("POST to /hello endpoint returned: ", postResult)
        XCTAssertTrue(postResult.contains("Hello from the other side, from swift-evolution-backend!"))
      } else {
        XCTFail("Return value from /hello POST was nil!")
      }

      printExpectation.fulfill()
    }

    waitForExpectations(timeout: 10.0, handler: nil)
  }

  func testGetJSON() {

    let printExpectation = expectation(description: "The /json endpoint will return a JSON object to the GET request")

    URLRequest(forTestWithMethod: "GET", route: "json")?
    .sendForTestingWithKitura { data in
      let getJSONResult = JSON(data: data)
      print("GET to /hello endpoint returned: ", getJSONResult)
      XCTAssertNotNil(getJSONResult, "GetHello string is nil")
      XCTAssertEqual(getJSONResult["framework"].string, "Kitura")
      XCTAssertEqual(getJSONResult["applicationName"].string, "swift-evolution-backend")
      XCTAssertEqual(getJSONResult["location"].string, "Austin, Texas")
      XCTAssertEqual(getJSONResult["company"].string, "IBM")
      XCTAssertEqual(getJSONResult["organization"].string, "Swift @ IBM")
      printExpectation.fulfill()
    }

    waitForExpectations(timeout: 10.0, handler: nil)
  }
}


private extension URLRequest {

  init?(forTestWithMethod method: String, route: String = "", body: Data? = nil) {
    if let url = URL(string: "http://127.0.0.1:8080/" + route){
      self.init(url: url)
      addValue("application/json", forHTTPHeaderField: "Content-Type")
      httpMethod = method
      cachePolicy = .reloadIgnoringCacheData
      if let body = body {
        httpBody = body
      }
    } else {
      XCTFail("URL is nil... )")
      return nil
    }
  }

  func sendForTestingWithKitura(fn: @escaping (Data) -> Void) {

    guard let method = httpMethod, var path = url?.path, let headers = allHTTPHeaderFields else {
      XCTFail("Invalid request params")
      return
    }

    if let query = url?.query {
      path += "?" + query
    }

    let requestOptions: [ClientRequest.Options] = [.method(method), .hostname("localhost"), .port(8080), .path(path), .headers(headers)]

    let req = HTTP.request(requestOptions) { resp in

      if let resp = resp, resp.statusCode == HTTPStatusCode.OK || resp.statusCode == HTTPStatusCode.accepted {
        do {
          var body = Data()
          try resp.readAllData(into: &body)
          fn(body)
        } catch {
          print("Bad JSON document received from swift-evolution-backend.")
        }
      } else {
        if let resp = resp {
          print("Status code: \(resp.statusCode)")
          var rawUserData = Data()
          do {
            let _ = try resp.read(into: &rawUserData)
            let str = String(data: rawUserData, encoding: String.Encoding(rawValue: String.Encoding.utf8.rawValue))
            print("Error response from swift-evolution-backend: \(String(describing: str))")
          } catch {
            print("Failed to read response data.")
          }
        }
      }
    }
    if let dataBody = httpBody {
      req.end(dataBody)
    } else {
      req.end()
    }
  }
}
