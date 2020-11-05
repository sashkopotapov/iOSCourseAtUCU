//
//  Note.swift
//  FunkyNotes
//
//  Created by Sashko Potapov on 04.10.2020.
//  Copyright © 2020 com.potapov. All rights reserved.
//

import Foundation

class Note: NoteProtocol {
       
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
    required init(with name: String, and text: String) {
        self.name = name
        self.text = text
        self.id = Note.getUniqueIdentifier()
    }
}

// MARK: - Open methods
extension Note {
    func changeName(to name: String) {
        self.name = name
    }
    
    func changeText(to text: String) {
        self.text = text
    }
    
    func addTag(_ tag: String) {
        tags.insert(tag)
    }
    
    func toggleIsFavourite() {
        isFavourite = !isFavourite
    }
    
    func markRemoved() {
        deletionDate = Date()
    }
    
    func markRestored() {
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

// MARK: - Protocol Conformance
extension Note: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}


