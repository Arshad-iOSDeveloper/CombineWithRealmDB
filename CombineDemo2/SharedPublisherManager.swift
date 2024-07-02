//
//  SharedPublisherManager.swift
//  CombineDemo2
//
//  Created by Arshad Shaik on 02/01/24.
//

import Foundation
import Combine

enum MyError: Error {
  case example
}

class SharedPublisherManager {
  
  static let shared = SharedPublisherManager()
  
  /// Example Just Publisher
  let justPublisher = Just("Just publisher")
  
  /// Example PassthroughSubject
  let passThroughSubject = PassthroughSubject<String, Never>()
  
  /// Example CurrentValueSubject
  let currentValueSubject = CurrentValueSubject<String, Never>("CurrentValue Subject")
  
  /// Example Future Publisher
  let futurePublisher = Future<String, Never> { promise in
    // Simulate an asynchronous operation
    DispatchQueue.global().async {
      // Provide the result (value)
      promise(.success("Future Value"))
    }
  }
  
  /// Example Empty Publisher
  let emptyPublisher = Empty<String, Never>()
  
  /// Example Fail Publisher
  let failPublisher = Fail<String, MyError>(error: MyError.example)
  
  private init() { }
  
}

