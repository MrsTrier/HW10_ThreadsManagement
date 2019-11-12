//
//  Example.swift
//  HW10_ThreadsManagement
//
//  Created by Roman Cheremin on 12/11/2019.
//  Copyright © 2019 Daria Cheremina. All rights reserved.
//

import Foundation


class Example {

    static let appendQueue = DispatchQueue(label: "com.example.append.queue",
                                           qos: .userInteractive,
                                           attributes: [.concurrent])
    static let demonstrationQueue = DispatchQueue(label: "com.demo.demonstration.queue",
                                             qos: .userInteractive)
    static let removeQueue = DispatchQueue(label: "com.example.remove.queue",
                                           qos: .userInteractive,
                                           attributes: [.concurrent])
    
    static func example() {
        print("Проверка безопасности коллекции на примере")
        
        let syncronizedCollection = TreadSaveCollection<Int>()
        
        appendQueue.async {
            for object in 0..<1000 {
                syncronizedCollection.append(object: object)
            }
        }

        print("Синхронная запись элементов в коллекцию завершена")

        demonstrationQueue.async {
            for index in 0..<1000 {
                guard let value = syncronizedCollection.get(element: index) as? Int else {
                    return
                }
                syncronizedCollection.set(at: index, object: value - 500)
            }
        }
        
        demonstrationQueue.async {
            for index in 0..<1000 {
                _ = syncronizedCollection.get(element: index)
            }
        }
        
        removeQueue.async {
            syncronizedCollection.delete(elem: 0)
        }
        removeQueue.async {
            syncronizedCollection.delete(elem: 490)
        }
    }
}
