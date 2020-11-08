//
//  NotesCoordinator.swift
//  FunkyNotes
//
//  Created by Sashko Potapov on 05.11.2020.
//  Copyright © 2020 com.potapov. All rights reserved.
//

import UIKit

final class NotesCoordinator: Coordinator {
    var navigationController: UINavigationController
    var childCoordinators: [Coordinator] = []
    
    var notesManager = NotesDataManager<Note>()
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let storyboard = UIStoryboard(name: "NotesList", bundle: nil)
        let vc = storyboard.instantiateViewController(identifier: "NotesListViewController") as! NotesListViewController
        vc.coordinator = self
        vc.notesManager = notesManager
        navigationController.pushViewController(vc, animated: true)
    }
    
    func showAddNewNote() {
        let storyboard = UIStoryboard(name: "Note", bundle: nil)
        let vc = storyboard.instantiateViewController(identifier: "NoteViewController") as! NoteViewController
        vc.coordinator = self
        vc.configureForAdding(manager: notesManager)
        navigationController.pushViewController(vc, animated: true)
    }
    
    func showEditNote(_ note: Note) {
        let storyboard = UIStoryboard(name: "Note", bundle: nil)
        let vc = storyboard.instantiateViewController(identifier: "NoteViewController") as! NoteViewController
        vc.coordinator = self
        vc.configureForEditing(manager: notesManager, note: note)
        navigationController.pushViewController(vc, animated: true)
    }
    
    func showNote(_ note: Note) {
        let storyboard = UIStoryboard(name: "Note", bundle: nil)
        let vc = storyboard.instantiateViewController(identifier: "NoteViewController") as! NoteViewController
        vc.coordinator = self
        vc.configureForViewing(manager: notesManager, note: note)
        navigationController.pushViewController(vc, animated: true)
    }
    
    func back() {
        navigationController.popViewController(animated: true)
    }
}
