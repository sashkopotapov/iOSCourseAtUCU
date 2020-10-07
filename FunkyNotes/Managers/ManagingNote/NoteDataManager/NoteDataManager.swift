//
//  FunkyNoteDataManager.swift
//  FunkyNotes
//
//  Created by Sashko Potapov on 04.10.2020.
//  Copyright © 2020 com.potapov. All rights reserved.
//

import Foundation

class NoteDataManager<T: NoteProtocol>: NoteDataManagerProtocol {
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
extension NoteDataManager {
    func createNote(with name: String, and text: String) {
        notes.append(T(with: name, and: text))
    }
    
    func removeNote(at index: Int) {
        guard notes.indices.contains(index) == true else { return }
        var note = notes[index]
        note.markRemoved()
        notes.remove(at: index)
        removedNotes.append(note)
    }
    
    func updateNote(at index: Int, with name: String? = nil, and text: String? = nil, addTag tag: String? = nil) {
        guard notes.indices.contains(index) == true else { return }
        if let name = name { notes[index].changeName(to: name) }
        if let text = text { notes[index].changeText(to: text) }
        if let tag = tag { notes[index].addTag(tag) }
    }
    
    func deleteNote(at index: Int) {
        guard removedNotes.indices.contains(index) == true else { return }
        removedNotes.remove(at: index)
    }
}
    
// MARK: - Supporting methods
extension NoteDataManager {
    func toggleNoteFavourite(at index: Int) {
        guard notes.indices.contains(index) == true else { return }
        notes[index].toggleIsFavourite()
    }
    
    func restoreNote(at index: Int) {
        guard removedNotes.indices.contains(index) == true else { return }
        var note = removedNotes[index]
        note.markRestored()
        notes.append(note)
        removedNotes.remove(at: index)
    }
}

// MARK: - Filtering, Searching & Sotring methods
extension NoteDataManager {
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
private extension NoteDataManager {
    
}
