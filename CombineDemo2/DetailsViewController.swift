//
//  DetailsViewController.swift
//  CombineDemo2
//
//  Created by Arshad Shaik on 29/12/23.
//

import UIKit
import Combine

class DetailsViewController: UIViewController {
  
  @IBOutlet weak var detailsTableView: UITableView!
  
//  private let viewController = ViewController()
  private var subscribers = Set<AnyCancellable>()
  
  var userNamePasswordText = ""
  
  override func viewDidLoad() {
    super.viewDidLoad()
    configuration()
    getDataFromPublisher()
  }
  
  func getDataFromPublisher() {
    if let viewController = navigationController?.viewControllers.first(where: { $0 is ViewController }) as? ViewController {
      viewController.userNamePasswordPublisher
        .sink { [weak self] (userName, password) in
          print("received values are \(userName) and \(password)")
          self?.userNamePasswordText = userName + ":" + password
          self?.detailsTableView.reloadData()
        }
        .store(in: &subscribers)
    }
  }
}

extension DetailsViewController: UITableViewDataSource{
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 1
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard var cell = tableView.dequeueReusableCell(withIdentifier: "cell") else{
      return UITableViewCell()
    }
    
    cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
    cell.textLabel?.text = userNamePasswordText
//    cell.detailTextLabel?.text = patientArray[indexPath.row].lastName
    
    return cell
  }
  
}

extension DetailsViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
    
    let edit = UIContextualAction(style: .normal, title: "Edit") { _, _, _ in
      
    }
    edit.backgroundColor = .magenta
    
    let delete = UIContextualAction(style: .destructive, title: "Delete") { _, _, _ in
      self.detailsTableView.reloadData()
    }
    
    let swipeConfiguration = UISwipeActionsConfiguration(actions: [delete, edit])
    return swipeConfiguration
    
  }
}

extension DetailsViewController{
  func configuration(){
    detailsTableView.dataSource = self
    detailsTableView.delegate = self
    detailsTableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
  }
}
