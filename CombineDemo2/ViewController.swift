//
//  ViewController.swift
//  CombineDemo2
//
//  Created by Arshad Shaik on 22/12/23.
//

import UIKit
import Combine

class ViewController: UIViewController {
  
  // MARK: - Outlets -
  @IBOutlet weak var userName: UITextField!
  @IBOutlet weak var password: UITextField!
  @IBOutlet weak var login: UIButton!
  @IBOutlet weak var freeText: UILabel!
  
  @Published var userNameText: String?
  @Published var passwordText: String?
  
  /// Subscriber
  private var subscribers: Set<AnyCancellable> = []
  var userNamePasswordPublisher = CurrentValueSubject<(String, String), Never>(("", ""))
  
  override func viewDidLoad() {
    super.viewDidLoad()
    userName.delegate = self
    password.delegate = self
    print("realm path ", RealmHandler.shared.getDatabasePath() as Any)
    enableLoginButtonAfterValidationSuccess()
    SharedPublisherManager.shared.passThroughSubject
      .sink { [weak self] value in
        self?.freeText.text = "pass through values are : \(value)"
      }.store(in: &subscribers)
  }
  
  // MARK: - Action -
  @IBAction func loginButtonTapped(_ sender: UIButton) {
    userNamePasswordPublisher.send((userName.text!, password.text!))
    
    /// Access Just Publisher
    SharedPublisherManager.shared.justPublisher
      .sink { value in
        print("value for just publisher: \(value)")
      }.store(in: &subscribers)
    
    SharedPublisherManager.shared.passThroughSubject.send("\(userName.text!) and \(password.text!)")
    
    SharedPublisherManager.shared.emptyPublisher
      .sink(receiveCompletion: { completion in
        print("Empty Publisher completion: ", completion)
      }, receiveValue: { value in
        print("Empty Publisher: \(value)")
      }).store(in: &subscribers)
    
    SharedPublisherManager.shared.failPublisher
      .sink { completion in
        print(completion)
      } receiveValue: { value in
        print("Fail publisher is: \(value)")
      }.store(in: &subscribers)

    goToDetailsView()
  }
  
  // MARK: - Helpers -
  func goToDetailsView() {
    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    let detailsVC = storyboard.instantiateViewController(withIdentifier: "DetailsViewController") as UIViewController
    self.navigationController?.pushViewController(detailsVC, animated: true)
  }
  
  func enableLoginButtonAfterValidationSuccess() {
    Publishers.CombineLatest($userNameText, $passwordText)
      .map { (userName, password) in
        guard let password = password else { return false }
        return !(userName?.isEmpty ?? true) && password.count >= 8
      }
      .assign(to: \.isEnabled, on: login)
      .store(in: &subscribers)
  }
}

extension ViewController: UITextFieldDelegate {
  func textFieldDidBeginEditing(_ textField: UITextField) {
    print(#function, textField.text as Any)
  }
  
  func textFieldDidEndEditing(_ textField: UITextField) {
    print(#function, textField.text as Any)
  }
  
  func textFieldDidChangeSelection(_ textField: UITextField) {
    if textField == userName {
      print("username is ", textField.text as Any)
      userNameText = textField.text
    } else {
      print("password is ", textField.text as Any)
      passwordText = textField.text
    }
  }
  
}
