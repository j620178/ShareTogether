//
//  NoteViewModelTests.swift
//  NoteViewModelTests
//
//  Created by littlema on 2019/10/12.
//  Copyright © 2019 littema. All rights reserved.
//

import XCTest
@testable import ShareTogether

class NoteViewModelTests: XCTestCase {
    
    var noteViewModel: NoteViewModel!
    
    var sut: URLSession!
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        noteViewModel = NoteViewModel()
        sut = URLSession(configuration: .default)
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        sut = nil
        super.tearDown()
    }
    
    func testFetchData() {
        
        let url = URL(string: "https://itunes.apple.com/search?media=music&entity=song&term=abba")
        // 1
        let promise = expectation(description: "Status code: 200")

        // when
        let dataTask = sut.dataTask(with: url!) { data, response, error in
          // then
          if let error = error {
            XCTFail("Error: \(error.localizedDescription)")
            return
          } else if let statusCode = (response as? HTTPURLResponse)?.statusCode {
            if statusCode == 200 {
              // 2
              promise.fulfill()
            } else {
              XCTFail("Status code: \(statusCode)")
            }
          }
        }
        dataTask.resume()
        // 3
        wait(for: [promise], timeout: 5)

    }
    
}
