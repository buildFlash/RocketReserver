//
//  MasterViewController.swift
//  RocketReserver
//
//  Created by Aryan Sharma on 24/07/20.
//  Copyright © 2020 Aryan Sharma. All rights reserved.
//

import UIKit
import SDWebImage

class MasterViewController: UITableViewController {

    var detailViewController: DetailViewController? = nil
    var launches = [LaunchListQuery.Data.Launch.Launch]()
    
    enum ListSection: Int, CaseIterable {
        case launches
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadLaunches()
    }

    override func viewWillAppear(_ animated: Bool) {
        clearsSelectionOnViewWillAppear = splitViewController!.isCollapsed
        super.viewWillAppear(animated)
    }


    // MARK: - Segues

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
      guard let selectedIndexPath = self.tableView.indexPathForSelectedRow else {
        // Nothing is selected, nothing to do
        return
      }
        
      guard let listSection = ListSection(rawValue: selectedIndexPath.section) else {
        assertionFailure("Invalid section")
        return
      }
        
      switch listSection {
      case .launches:
        guard
          let destination = segue.destination as? UINavigationController,
          let detail = destination.topViewController as? DetailViewController else {
            assertionFailure("Wrong kind of destination")
            return
        }
        
        let launch = self.launches[selectedIndexPath.row]
        detail.launchID = launch.id
        self.detailViewController = detail
      }
    }
    // MARK: - Table View

    override func numberOfSections(in tableView: UITableView) -> Int {
        return ListSection.allCases.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let listSection = ListSection(rawValue: section) else {
            assertionFailure("Invalid Section")
            return 0
        }
        switch listSection {
            case .launches:
                return self.launches.count
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.imageView?.image = nil
        cell.textLabel?.text = nil
        cell.detailTextLabel?.text = nil
        guard let listSection = ListSection(rawValue: indexPath.section) else {
            assertionFailure("Invalid section")
            return cell
        }

        switch listSection {
        case .launches:
            let launch = self.launches[indexPath.row]
            cell.textLabel?.text = launch.site
            let placeholder = UIImage(named: "placeholder")!
              
            if let missionPatch = launch.mission?.missionPatch {
              cell.imageView?.sd_setImage(with: URL(string: missionPatch)!, placeholderImage: placeholder)
            } else {
              cell.imageView?.image = placeholder
            }

        }
        
        return cell
    }
    
    private func showErrorAlert(title: String, message: String) {
        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        self.present(alert, animated: true)
    }
    
    private func loadLaunches() {
      Network.shared.apollo
        .fetch(query: LaunchListQuery()) { [weak self] result in
        
          guard let self = self else {
            return
          }

          defer {
            self.tableView.reloadData()
          }
                
          switch result {
          case .success(let graphQLResult):
            if let launchConnection = graphQLResult.data?.launches {
              self.launches.append(contentsOf: launchConnection.launches.compactMap { $0 })
            }
                    
            if let errors = graphQLResult.errors {
              let message = errors
                    .map { $0.localizedDescription }
                    .joined(separator: "\n")
              self.showErrorAlert(title: "GraphQL Error(s)",
                                  message: message)
            }
          case .failure(let error):
            self.showErrorAlert(title: "Network Error",
                                message: error.localizedDescription)
          }
      }
    }

}

