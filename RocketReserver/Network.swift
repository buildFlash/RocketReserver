//
//  Network.swift
//  RocketReserver
//
//  Created by Aryan Sharma on 24/07/20.
//  Copyright © 2020 Aryan Sharma. All rights reserved.
//

import Foundation
import Apollo

class Network {
  static let shared = Network()
    
  private(set) lazy var apollo = ApolloClient(url: URL(string: "https://apollo-fullstack-tutorial.herokuapp.com/graphql")!)
}
