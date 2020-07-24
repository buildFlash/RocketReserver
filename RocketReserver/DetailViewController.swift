//
//  DetailViewController.swift
//  RocketReserver
//
//  Created by Aryan Sharma on 24/07/20.
//  Copyright © 2020 Aryan Sharma. All rights reserved.
//

import UIKit
import Apollo

class DetailViewController: UIViewController {
    
    var launchID: GraphQLID? {
      didSet {
        self.configureView()
      }
    }

    @IBOutlet weak var detailDescriptionLabel: UILabel!


    func configureView() {
      // Update the user interface for the detail item.
      guard
        let label = self.detailDescriptionLabel,
        let id = self.launchID else {
          return
      }

      label.text = "Launch \(id)"
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        configureView()
    }

    var detailItem: NSDate? {
        didSet {
            // Update the view.
            configureView()
        }
    }


}

