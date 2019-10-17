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
    
    var sut: NoteViewModel!
    
    var mockFirestoreManager: MockFirestoreManager!
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        mockFirestoreManager = MockFirestoreManager()
        sut = NoteViewModel(manager: mockFirestoreManager)
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        sut = nil
        super.tearDown()
    }
    
    func test_fetchData_success() {
        // Given
        mockFirestoreManager.completeNotes = [Note]()

        // When
        sut.fetchData(groupID: "r2faZu22KX4ZbG7Fv86A")
    
        // Assert
        XCTAssert(mockFirestoreManager.isisFetchNotesCalled)
    }
    
    func test_fetchData_fail() {
        // Given
        let error = FirestoreError.decodeFailed

        // When
        sut.fetchData(groupID: "r2faZu22KX4ZbG7Fv86A")
        
        mockFirestoreManager.fetchFail(error: .decodeFailed)
            
        // Assert
        XCTAssertEqual(sut.alertString, error.rawValue)
    }
    
}

class MockFirestoreManager: FirestoreManagerProtocol {
    
    func getNotes(groupID: String?, completion: @escaping (Result<[Note], FirestoreError>) -> Void) {
        isisFetchNotesCalled = true
        completeClosure = completion
    }
    
    var isisFetchNotesCalled = false
    
    var completeNotes: [Note] = [Note]()
    
    var completeClosure: ((Result<[Note], FirestoreError>) -> Void)!
    
    func fetchSuccess() {
        
        completeClosure(Result.success(completeNotes))
    }
    
    func fetchFail(error: FirestoreError) {
        completeClosure(Result.failure(error))
    }
    
}

class StubGenerator {
    func stubNotes() -> [Note] {
        var notes = [Note]()
        notes.append(Note(id: nil,
                          content: "Ker1",
                          auctorID: "test",
                          comments: nil,
                          time: Date()))
        notes.append(Note(id: nil,
                          content: "Ker2",
                          auctorID: "test",
                          comments: nil,
                          time: Date()))
        notes.append(Note(id: nil,
                          content: "Ker3",
                          auctorID: "test",
                          comments: nil,
                          time: Date()))
        return notes
    }
}
