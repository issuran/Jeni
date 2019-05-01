//
//  Coordinator.swift
//  Jeni
//
//  Created by Tiago Oliveira on 01/05/19.
//  Copyright © 2019 Tiago Oliveira. All rights reserved.
//

import UIKit

protocol Coordinator {
    var window: UIWindow { get set }
    var navigationController: UINavigationController { get set }
    
    init(window: UIWindow)
    
    func start()
}
