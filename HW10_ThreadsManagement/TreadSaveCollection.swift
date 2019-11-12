//
//  TreadSaveCollection.swift
//  HW10_ThreadsManagement
//
//  Created by Roman Cheremin on 12/11/2019.
//  Copyright © 2019 Daria Cheremina. All rights reserved.
//

import UIKit

public class TreadSaveCollection<T: Equatable> {
    private var _array: [T];
    private let collectionQueue = DispatchQueue(label: "com.collection.queue", attributes: .concurrent)
    
    init() {
        _array = []
    }
    
    func append(object: T) {
        collectionQueue.async(flags: .barrier) {
            self._array.append(object)
            print("You appended \(object)")
        }
    }
    
    func set(at index: Int, object: T) {
        collectionQueue.async (flags: .barrier) {
            print("You setted \(object) at \(index)")
            self._array[index] = object
        }
    }

    func get(element: T) -> Any? {
        var res: Any?
        collectionQueue.sync{
            if (someElement(element: element)) {
                print("Element with value \(element) found in collection at index \(self._array.firstIndex(of: element)!)")
                res = self._array.firstIndex(of: element)
            } else {
                res = nil
            }
        }
        return res
    }
    
    func delete (elem: T) {
        collectionQueue.async (flags: .barrier) {
            if let index = self._array.firstIndex(of: elem) {
                self._array.remove(at: index)
                print("Element with value \(elem) deleted from collection")
            } else {
                print("Sorry, there is no such element as \(elem). It can't be deletted")
            }
        }
    }
    
    private func someElement(element: T) -> Bool {
//        if (index > self._array.count - 1) {
        if !(self._array.contains(element)) {
            print("Element \(element) couldn't be found in the collection")
            return false
        }
        return true
    }
}
