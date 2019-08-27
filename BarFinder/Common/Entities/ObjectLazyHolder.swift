//
//  ObjectLazyHolder.swift
//  StickersCollection
//
//  Created by Nikola Milovanovic on 5/4/18.
//  Copyright © 2018 Nikola Milovanovic. All rights reserved.
//

import Foundation

// ObjectLazyHolder is used in App singleton for enabling lazy initialization. It other purpose is possability to change its value durring runtime. It is used for unit tests, as when creating unit test we want possibaility to use Mocks or Stubs for singelton used by object that we are testing.

struct ObjectLazyHolder<Object> {
  private var prevValue: Object?
  private var value: Object?
  
  private var creator: () -> Object
  
  /// creator is method that will create object when getter is called
  init(creator: @escaping () -> Object) {
    self.creator = creator
  }
  
  /// helper initializer, to avoid brackets
  init(creator: @escaping @autoclosure () -> Object) {
    self.creator = creator
  }
  
  /// If current value is nil, it will create it and then return it. If it is not nil it will return it.
  mutating func getValue() -> Object {
    if value == nil {
      value = creator()
    }
    
    return value!
  }
  
  /// method for pushing new value. It should be used only for unit tests.
  mutating func push(_ newValue: Object) {
    prevValue = value
    value = newValue
  }
  
  /// method for poping pushed value. It should be used only for unit tests. It must be called by after push is called.
  mutating func pop() {
    value = prevValue
    prevValue = nil
  }
}
