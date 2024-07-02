//
//  UserDetailsModel.swift
//  CombineDemo2
//
//  Created by Arshad Shaik on 27/12/23.
//

import Foundation
import RealmSwift
import Combine

class UserDetails: Object {
  @Persisted(primaryKey: true) var userId: String = UUID().uuidString
  @Persisted var name: String
  @Persisted var password: String
}

class UserDetailsViewModel {
  var username: String = ""
  var password: String = ""
}

struct ViewModel {
  let userName: String
  let password: String
}
