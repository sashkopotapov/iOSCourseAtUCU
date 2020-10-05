//
//  NotesManager.swift
//  FunkyNotes
//
//  Created by Sashko Potapov on 04.10.2020.
//  Copyright © 2020 com.potapov. All rights reserved.
//

import Foundation

protocol NoteDataManagerProtocol {
    associatedtype T = NoteProtocol
    
    // MARK: - Private Properties
    var notes: [T] { get }
    var removedNotes: [T] { get }
    
    // MARK: - CRUD methods
    func createNote(with name: String, and text: String)
    func removeNote(at index: Int)
    func updateNote(at index: Int, with name: String?, and text: String?)
    func deleteNote(at index: Int)
    
    // MARK: - Supporting methods
    func toggleNoteFavourite(at index: Int)
    func restoreNote(at index: Int)
    
    // MARK: - Filtering, Searching & Sotring methods
    func filter(by tag: String) -> [T]
    func filter(by date: Date) -> [T]
    func search(by name: String) -> [T]
    func sort(by tag: String) -> [T]
    func sort(by date: Date) -> [T]
}
