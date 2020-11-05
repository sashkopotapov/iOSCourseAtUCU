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
    private var _note: Note?
    private var _mode: Mode = .editing
    
    private var note: Note? {
        didSet {
            if note != nil {
                nameLabel.text = note?.name
                textTextView.text = note?.text
                tagsTextField.text = note?.tags.description
            }
        }
    }
    
    private var mode: Mode = .editing {
        didSet {
            if mode == .editing {
                setupNavigationBarEditing()
                enableFields()
            }
            else {
                setupNavigationBarRegular()
                disableFields()
            }
        }
    }
    
    private var notesManager: NotesDataManager<Note>?
    
    // MARK: - Delegates
    weak var coordinator: NotesCoordinator?
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBarEditing()
        mode = _mode
        note = _note
    }
}

// MARK: - Open Methods
extension NoteViewController {
    func configure(with note: Note? = nil, mode: Mode, manager: NotesDataManager<Note>) {
        if note != nil { self._note = note }
        self.notesManager = manager
        self._mode = mode
    }
}
// MARK: - IBAction & Target Actions
extension NoteViewController {
    @objc func saveNoteAction() {
        guard let name = nameLabel.text else {
            showAlert("Error", and: "Please, give a name to your note.")
            return
        }
        
        notesManager?.createNote(with: name,
                            and: textTextView.text ?? "")
        
//        if tagsTextField.hasText {
//            manager?.updateNote(at: manager!.notes.count - 1,
//                                addTag: tagsTextField.text ?? "")
//        }
        
        showAlert("Success", and: "Note successfully created.") { [weak self] in
            self?.coordinator?.back()
        }
    }
    
    @objc func editNoteAction() {
        mode = .editing
    }
}

// MARK: - Private Methods
private extension NoteViewController {
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
        
        navigationItem.setRightBarButton(addItem, animated: true)
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    func enableFields() {
        nameLabel.isUserInteractionEnabled = true
        tagsTextField.isUserInteractionEnabled = true
        textTextView.isUserInteractionEnabled = true
    }
    
    func disableFields() {
        nameLabel.isUserInteractionEnabled = false
        tagsTextField.isUserInteractionEnabled = false
        textTextView.isUserInteractionEnabled = false
    }
}

// MARK: - Delegate Conformance
