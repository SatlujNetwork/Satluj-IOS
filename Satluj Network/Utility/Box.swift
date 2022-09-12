//
//  Box.swift
//  Satluj Network
//
//  Created by Mohit on 14/03/22.
//

import Foundation
class Box<T>{
    
    typealias Listener = (T)->Void
    
    var listener : Listener?
    var value : T{
        didSet{
            listener?(value)
        }
    }
    
    init(_ value:T) {
        self.value = value
    }
    
    //4
    func bind(listener: Listener?) {
      self.listener = listener
      listener?(value)
    }
    
}
