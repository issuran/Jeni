//
//  Observable.swift
//  Jeni
//
//  Created by Tiago Oliveira on 20/05/19.
//  Copyright © 2019 Tiago Oliveira. All rights reserved.
//

import Foundation

class Observable<T> {
    fileprivate var _value: T?
    var didChange: ((T) -> Void)?
    var value: T {
        set {
            _value = newValue
            didChange?(_value!)
        }
        get {
            return _value!
        }
    }
    
    init(_ value: T) {
        self.value = value
    }
    
    deinit {
        _value = nil
        didChange = nil
    }
}
