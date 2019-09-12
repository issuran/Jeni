//
//  SnapshotExtensions.swift
//  Jeni
//
//  Created by Tiago Oliveira on 05/06/19.
//  Copyright © 2019 Tiago Oliveira. All rights reserved.
//

import Foundation
import FirebaseFirestore

extension QueryDocumentSnapshot {
    func decoded<T: Decodable>() throws -> T {
        let jsonData = try JSONSerialization.data(withJSONObject: data(), options: [])
        let object = try JSONDecoder().decode(T.self, from: jsonData)
        return object
    }
}

extension QuerySnapshot {
    func decoded<T: Decodable>() throws -> [T] {
        let objects: [T] = try documents.map({ try $0.decoded() })
        return objects
    }
}
