//
//  FunkyNoteDataManager.swift
//  FunkyNotes
//
//  Created by Sashko Potapov on 04.10.2020.
//  Copyright © 2020 com.potapov. All rights reserved.
//

import Foundation

class NotesDataManager<T: NoteProtocol>: NotesDataManagerProtocol {
    
    // MARK: - Private properties
    private(set) var notes: [T]
    private(set) var removedNotes: [T]
    
    // MARK: - Public properties
    
    // MARK: - Lifecycle
    init() {
        // Possibly fetch from persistence here
        notes = []
        removedNotes = []
    }
}

// MARK: - Open methods
// MARK: - CRUD methods
extension NotesDataManager {
    func createNote(with name: String, and text: String) {
        notes.append(T(with: name, and: text))
    }
    
    func removeNote(with id: Int) -> Bool {
        for (index, v) in notes.enumerated() {
            var note = v
            if note.id == id {
                note.markRemoved()
                notes.remove(at: index)
                removedNotes.append(note)
                return true
            }
        }
        return false
    }
    
    func deleteNote(with id: Int) -> Bool {
        for (index, v) in notes.enumerated() {
            if v.id == id {
                notes.remove(at: index)
                return true
            }
        }
        return false
    }
}
    
// MARK: - Supporting methods
extension NotesDataManager {
    func restoreNote(with id: Int) -> Bool {
        for (index, v) in removedNotes.enumerated() {
            var note = v
            if note.id == id {
                note.markRestored()
                notes.append(note)
                removedNotes.remove(at: index)
                return true
            }
        }
        return false
    }
}

// MARK: - Filtering, Searching & Sotring methods
extension NotesDataManager {
    func filter(by tag: String) -> [T] {
        return notes.filter { $0.tags.contains(tag) }
    }
    
    func filter(by date: Date) -> [T] {
       return notes.filter { $0.creationDate < date }
    }
    
    func search(by name: String) -> [T] {
        return notes.filter { $0.name == name }
    }
    
    func sort(by tag: String) -> [T] {
        return []
    }
    
    func sort(by date: Date) -> [T] {
        return notes.sorted { $0.creationDate < $1.creationDate }
    }
}

// MARK: - Private methods
private extension NotesDataManager {
    
}
