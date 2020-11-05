//
//  NotesListViewController.swift
//  FunkyNotes
//
//  Created by Sashko Potapov on 05.11.2020.
//  Copyright © 2020 com.potapov. All rights reserved.
//

import UIKit

class NotesListViewController: UIViewController {

    // MARK: - IBOutlets & Views
    @IBOutlet private weak var tableView: UITableView!
    
    // MARK: - Properties
    var notesManager: NotesDataManager<Note>!
    
    private var notesDataSource: [Note] = []
    
    // MARK: - Delegates
    weak var coordinator: NotesCoordinator?
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupNavigationBarRegular()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        notesDataSource = notesManager.notes
        tableView.reloadData()
    }
}

// MARK: - Open Methods

// MARK: - IBAction & Target Actions
extension NotesListViewController {
    @objc func addNewNoteAction() {
        coordinator?.showAddNewNote()
    }
    
    @objc func showRemovedNotesAction() {
        notesDataSource = notesManager.removedNotes
        tableView.reloadData()
        setupNavigationBarForDeletedNotes()
    }
    
    @objc func showNotes() {
        notesDataSource = notesManager.notes
        tableView.reloadData()
        setupNavigationBarRegular()
    }
}

// MARK: - Private Methods
private extension NotesListViewController {
    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func setupNavigationBarRegular() {
        let addItem = UIBarButtonItem(barButtonSystemItem: .add,
                                      target: self,
                                      action: #selector(addNewNoteAction))
        
        let deletedItem = UIBarButtonItem(barButtonSystemItem: .trash,
                                          target: self,
                                          action: #selector(showRemovedNotesAction))
        
        navigationItem.setLeftBarButton(deletedItem, animated: true)
        navigationItem.setRightBarButton(addItem, animated: true)
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "Notes"
    }
    
    func setupNavigationBarForDeletedNotes() {
        let backItem = UIBarButtonItem(title: "Notes",
                                       style: .plain,
                                       target: self,
                                       action: #selector(showNotes))
        
        navigationItem.setLeftBarButton(backItem, animated: true)
        navigationItem.setRightBarButton(nil, animated: true)
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "Deleted Notes"
    }
}

// MARK: - Delegate Conformance
extension NotesListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let note = notesManager.notes[indexPath.row]
        coordinator?.showNote(note)
    }
}

extension NotesListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notesDataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NoteTableViewCell")
        cell?.textLabel?.text = notesDataSource[indexPath.row].name
        cell?.detailTextLabel?.text = notesDataSource[indexPath.row].text
        return cell!
    }
}
