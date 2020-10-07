//
//  Note.swift
//  FunkyNotes
//
//  Created by Sashko Potapov on 04.10.2020.
//  Copyright © 2020 com.potapov. All rights reserved.
//

import Foundation

struct Note: NoteProtocol {
       
    // MARK: - Public properties
    let id: Int
    
    // MARK: - Private properties
    private(set) var name: String
    private(set) var text: String
    private(set) var tags = Set<String>()
    private(set) var isFavourite: Bool = false
    private(set) var creationDate: Date = Date()
    private(set) var deletionDate: Date?
    
    private static var identifierFactory = 0
    
    // MARK: - Lifecycle
    init(with name: String, and text: String) {
        self.name = name
        self.text = text
        self.id = Note.getUniqueIdentifier()
    }
}

// MARK: - Open methods
extension Note {
    mutating func changeName(to name: String) {
        self.name = name
    }
    
    mutating func changeText(to text: String) {
        self.text = text
    }
    
    mutating func addTag(_ tag: String) {
        tags.insert(tag)
    }
    
    mutating func toggleIsFavourite() {
        isFavourite = !isFavourite
    }
    
    mutating func markRemoved() {
        deletionDate = Date()
    }
    
    mutating func markRestored() {
        deletionDate = nil
    }
}

// MARK: - Private methods
private extension Note {
    
}

// MARK: - Static methods
extension Note {
    static func == (lhs: Note, rhs: Note) -> Bool {
        lhs.id == rhs.id
    }
    
    static func getUniqueIdentifier() -> Int {
        Note.identifierFactory += 1
        return Note.identifierFactory
    }
}
