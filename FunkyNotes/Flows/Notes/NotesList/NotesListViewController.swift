//
//  NotesListViewController.swift
//  FunkyNotes
//
//  Created by Sashko Potapov on 05.11.2020.
//  Copyright © 2020 com.potapov. All rights reserved.
//

import UIKit

class NotesListViewController: UIViewController {
    
    enum Mode {
        case archive
        case regular
    }
    
    // MARK: - IBOutlets & Views
    @IBOutlet private weak var tableView: UITableView!
    
    // MARK: - Properties
    var notesManager: NotesDataManager<Note>!
    
    private var notesDataSource: [Note] = []
    private var mode: Mode = .regular
    
    // MARK: - Delegates
    weak var coordinator: NotesCoordinator?
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        showNotes()
    }
}

// MARK: - Open Methods

// MARK: - IBAction & Target Actions
extension NotesListViewController {
    @objc func addNewNoteAction() {
        coordinator?.showAddNewNote()
    }
    
    @objc func showRemovedNotes() {
        mode = .archive
        notesDataSource = notesManager.removedNotes
        tableView.reloadData()
        setupNavigationBarForDeletedNotes()
        tableView.allowsSelection = false
        navigationItem.searchController = nil
    }
    
    @objc func showNotes() {
        mode = .regular
        notesDataSource = notesManager.notes
        tableView.reloadData()
        setupNavigationBarRegular()
        tableView.allowsSelection = true
        setupSearchBar()
    }
}

// MARK: - Private Methods
private extension NotesListViewController {
    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.isEditing = true
    }
    
    func setupNavigationBarRegular() {
        let addItem = UIBarButtonItem(barButtonSystemItem: .add,
                                      target: self,
                                      action: #selector(addNewNoteAction))
        
        let deletedItem = UIBarButtonItem(title: "Trash",
                                          style: .plain,
                                          target: self,
                                          action: #selector(showRemovedNotes))
        
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
    
    func setupSearchBar() {
        let search = UISearchController(searchResultsController: nil)
        search.searchResultsUpdater = self
        search.delegate = self
        search.obscuresBackgroundDuringPresentation = false
        search.searchBar.placeholder = "Search by name"
        navigationItem.searchController = search
    }
}

// MARK: - Delegate Conformance
extension NotesListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let note = notesManager.notes[indexPath.row]
        coordinator?.showNote(note)
    }

    func tableView(_ tableView: UITableView,
                   trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let id = notesDataSource[indexPath.row].id

        if mode == .archive {
            let restoreAction = UIContextualAction(style: .normal, title: "Restore") { (_, _, completionHandler) in
                if self.notesManager.restoreNote(with: id) {
                    self.showAlert("Success", and: "Successfully restored note.")
                    self.notesDataSource = self.notesManager.removedNotes
                    self.tableView.reloadData()
                } else {
                    self.showAlert("Failure", and: "Failed to restore note.")
                }
                completionHandler(true)
            }
            restoreAction.backgroundColor = .systemYellow
            let configuration = UISwipeActionsConfiguration(actions: [restoreAction])
            return configuration
        } else  {
            let removeAction = UIContextualAction(style: .normal, title: "Remove") { (_, _, completionHandler) in
                if self.notesManager.deleteNote(with: id) {
                    self.showAlert("Success", and: "Successfully removed note.")
                    self.notesDataSource = self.notesManager.notes
                    self.tableView.reloadData()
                } else {
                    self.showAlert("Failure", and: "Failed to restore note.")
                }
                completionHandler(true)
            }
            removeAction.backgroundColor = .systemRed
            let configuration = UISwipeActionsConfiguration(actions: [removeAction])
            return configuration
        }
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
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let movedObject = notesDataSource[sourceIndexPath.row]
        notesDataSource.remove(at: sourceIndexPath.row)
        notesDataSource.insert(movedObject, at: destinationIndexPath.row)
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .none
    }

    func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        return false
    }
}

extension NotesListViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else { return }
        self.notesDataSource = notesManager.search(by: text)
        tableView.reloadData()
    }
}

extension NotesListViewController: UISearchControllerDelegate {
    func didDismissSearchController(_ searchController: UISearchController) {
        self.notesDataSource = notesManager.notes
        tableView.reloadData()
    }
}
