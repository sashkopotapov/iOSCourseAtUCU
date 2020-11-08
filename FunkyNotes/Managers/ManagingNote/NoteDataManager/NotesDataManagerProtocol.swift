//
//  NotesManager.swift
//  FunkyNotes
//
//  Created by Sashko Potapov on 04.10.2020.
//  Copyright © 2020 com.potapov. All rights reserved.
//

import Foundation

protocol NotesDataManagerProtocol {
    associatedtype T = NoteProtocol
    
    // MARK: - Private Properties
    var notes: [T] { get }
    var removedNotes: [T] { get }
    
    // MARK: - CRUD methods
    func createNote(with name: String, and text: String)
    func removeNote(with id: Int) -> Bool
    func deleteNote(with id: Int) -> Bool
    
    // MARK: - Supporting methods
    func restoreNote(with id: Int) -> Bool
    
    // MARK: - Filtering, Searching & Sotring methods
    func filter(by tag: String) -> [T]
    func filter(by date: Date) -> [T]
    func search(by name: String) -> [T]
    func sort(by tag: String) -> [T]
    func sort(by date: Date) -> [T]
}
