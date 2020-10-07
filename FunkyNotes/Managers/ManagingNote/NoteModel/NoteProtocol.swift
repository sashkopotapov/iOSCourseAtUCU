//
//  NoteProtocol.swift
//  FunkyNotes
//
//  Created by Sashko Potapov on 04.10.2020.
//  Copyright © 2020 com.potapov. All rights reserved.
//

import Foundation

protocol NoteProtocol: Hashable {
    // MARK: - Private properties
    var id: Int { get }
    var name: String { get }
    var text: String { get }
    var tags: Set<String> { get }
    var isFavourite: Bool { get }
    var creationDate: Date { get }
    var deletionDate: Date? { get }
    
    // MARK: - Init
    init(with name: String, and text: String)
    
    // MARK: - Setting methods
    mutating func changeName(to name: String)
    mutating func changeText(to text: String)
    mutating func addTag(_ tag: String)
    mutating func toggleIsFavourite()
    mutating func markRemoved()
    mutating func markRestored()
}
