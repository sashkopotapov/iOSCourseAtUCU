//
//  NoteViewController.swift
//  FunkyNotes
//
//  Created by Sashko Potapov on 05.11.2020.
//  Copyright © 2020 com.potapov. All rights reserved.
//

import UIKit

final class NoteViewController: UIViewController {

    enum Mode {
        case editing
        case viewing
    }
    
    // MARK: - IBOutlets & Views
    @IBOutlet private weak var nameLabel: UITextField!
    @IBOutlet private weak var tagsTextField: UITextField!
    @IBOutlet private weak var textTextView: UITextView!
    
    // MARK: - Properties
    private var note: Note?
    private var mode: Mode = .viewing
    private var notesManager: NotesDataManager<Note>?
    
    // MARK: - Delegates
    weak var coordinator: NotesCoordinator?
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBarEditing()
        setupUI()
    }
}

// MARK: - Open Methods
extension NoteViewController {
    func configureForAdding(manager: NotesDataManager<Note>) {
        notesManager = manager
        mode = .editing
    }
    
    func configureForEditing(manager: NotesDataManager<Note>, note: Note) {
        notesManager = manager
        self.note = note
        mode = .editing
    }
    
    func configureForViewing(manager: NotesDataManager<Note>, note: Note) {
        notesManager = manager
        self.note = note
        mode = .viewing
    }
}
// MARK: - IBAction & Target Actions
extension NoteViewController {
    @objc func saveNoteAction() {
        guard let name = nameLabel.text else {
            showAlert("Error", and: "Please, give a name to your note.")
            return
        }
        
        if note == nil {
            notesManager?.createNote(with: name,
                                     and: textTextView.text)
        } else {
            note?.changeName(to: name)
            note?.changeText(to: textTextView.text)
        }
        
        showAlert("Success", and: "Note successfully saved.") {
            self.coordinator?.back()
        }
    }
    
    @objc func editNoteAction() {
        mode = .editing
        updateViewAccordingToMode()
    }
    
    @objc func deleteNoteAction() {
        guard let note = note else {
            return
        }
        
        if notesManager!.removeNote(with: note.id) {
            showAlert("Success", and: "Note successfully deleted.") {
                self.coordinator?.back()
            }
        } else {
            showAlert("Failure", and: "Something went wrong.") {
                self.coordinator?.back()
            }
        }
    }
}

// MARK: - Private Methods
private extension NoteViewController {
    func setupUI() {
        fillNoteFieldsFromModel()
        updateViewAccordingToMode()
    }
    
    func setupNavigationBarEditing() {
        let addItem = UIBarButtonItem(title: "Save",
                                      style: .done,
                                      target: self,
                                      action: #selector(saveNoteAction))
        
        navigationItem.setRightBarButton(addItem, animated: true)
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    func setupNavigationBarRegular() {
        let addItem = UIBarButtonItem(title: "Edit",
                                      style: .plain,
                                      target: self,
                                      action: #selector(editNoteAction))
        
        let deleteItem = UIBarButtonItem(barButtonSystemItem: .trash,
                                         target: self,
                                         action: #selector(deleteNoteAction))
        
        navigationItem.setRightBarButtonItems([addItem, deleteItem], animated: true)
         navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    func enableEditingFields() {
        nameLabel.isUserInteractionEnabled = true
        tagsTextField.isUserInteractionEnabled = true
        textTextView.isUserInteractionEnabled = true
    }
    
    func disableEditingFields() {
        nameLabel.isUserInteractionEnabled = false
        tagsTextField.isUserInteractionEnabled = false
        textTextView.isUserInteractionEnabled = false
    }
    
    func fillNoteFieldsFromModel() {
        guard let note = note else {
            return
        }
        nameLabel.text = note.name
        textTextView.text = note.text
        tagsTextField.text = note.tags.description
    }
    
    func updateViewAccordingToMode() {
        if mode == .editing {
            enableEditingFields()
            setupNavigationBarEditing()
        } else {
            disableEditingFields()
            setupNavigationBarRegular()
        }
    }
}

// MARK: - Delegate Conformance
