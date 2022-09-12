//
//  Bindable.swift
//  Satluj Network
//
//  Created by Brahma Naidu on 02/04/22.
//

import Foundation
final class Bindable <T> {
    //1
    typealias Listener = (T) -> Void
    var listener : Listener?
    //2
    var value: T {
        didSet {
            listener?(value)
        }
    }
    //3
    init(_ value: T) {
        self.value = value
    }
    //4
    func bind(listener: Listener?){
        self.listener = listener
        listener?(value)
    }
}
