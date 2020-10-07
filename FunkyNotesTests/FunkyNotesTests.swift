//
//  FunkyNotesTests.swift
//  FunkyNotesTests
//
//  Created by Sashko Potapov on 04.10.2020.
//  Copyright © 2020 com.potapov. All rights reserved.
//

import XCTest
@testable import FunkyNotes

class FunkyNotesTests: XCTestCase {
    
    var manager: NoteDataManager<Note>!
    
    // MARK: - Testing Notes Data Manager
    override func setUp() {
        super.setUp()
        manager = NoteDataManager()
    }
    
    func testSetup() {
        XCTAssertTrue(manager.notes.isEmpty, "❗️Notes manager is not empty after setup.")
    }
    
    func testManager() {
        // Creating note
        let title = "Hello, World!"
        let text = "This is the initial note."
        manager.createNote(with: title, and: text)
        XCTAssertTrue(manager.notes.count == 1, "❗️Creating one Note produces more tha one inside manager.")
        
        // Testing for note diffs
        let note = Note(with: title, and: text)
        XCTAssertNotEqual(manager.notes.first!, note, "❗️Two different notes are equal.")
        
        // Removing note
        manager.removeNote(at: 0)
        XCTAssertTrue(manager.notes.isEmpty,  "❗️Managers still contains notes after removing them.")
        XCTAssertTrue(manager.removedNotes.count == 1,  "❗️Manager does not contain removed notes.")
        
        // Restoringn note
        manager.restoreNote(at: 0)
        XCTAssertTrue(manager.notes.count == 1,  "❗️Manager failed to restore note.")
        XCTAssertTrue(manager.removedNotes.isEmpty,  "❗️Manager did not remove restored note from archive.")
        
        // Deleting note
        manager.removeNote(at: 0)
        manager.deleteNote(at: 0)
        XCTAssertTrue(manager.removedNotes.isEmpty,  "❗️Manager failed to delete removed note.")
        
        // Updating note
        let newTitle = "Hi, Serj!"
        manager.createNote(with: title, and: text)
        manager.updateNote(at: 0, with: newTitle)
        XCTAssertEqual(manager.notes.first!.name, newTitle, "❗️Failed to update note title.")
        
        // Toggling favourite
        manager.toggleNoteFavourite(at: 0)
        XCTAssertTrue(manager.notes.first!.isFavourite, "❗️Manager failed to toggle isFavourite for note.")
        manager.toggleNoteFavourite(at: 0)
        XCTAssertFalse(manager.notes.first!.isFavourite, "❗️Manager failed to toggle isFavourite for note.")
        
        // Search for note
        let noteName = "Hello, Sashko!"
        manager.createNote(with: noteName, and: "Second note.")
        XCTAssertEqual(manager.search(by: noteName).first!.name, noteName, "❗️Failed to search note by its name.")

        // Filter notes
        manager.updateNote(at: 0, addTag: "Family")
        XCTAssertTrue(manager.filter(by: "Family").count == 1, "❗️Failed to filter note by its tag.")
    }
}
