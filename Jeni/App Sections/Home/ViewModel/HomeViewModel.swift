//
//  HomeViewModel.swift
//  Jeni
//
//  Created by Tiago Oliveira on 04/05/19.
//  Copyright © 2019 Tiago Oliveira. All rights reserved.
//

import Foundation

class HomeViewModel {
    
    weak var delegate: HomeCoordinatorDelegate!
    
    func logout() {
        delegate.callLogin(self)
    }
}
