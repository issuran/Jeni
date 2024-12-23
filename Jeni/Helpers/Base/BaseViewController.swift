//
//  BaseViewController.swift
//  Jeni
//
//  Created by Tiago Oliveira on 04/05/19.
//  Copyright © 2019 Tiago Oliveira. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {
    
    typealias Handler = () -> Void
    static var medicineItemArray : [MedicineModel] = []
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(BaseViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
    }
    
    func alert(message: String, title: String = "") {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        
        alert.addAction(OKAction)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func alert(message: String, title: String = "", completion: @escaping Handler) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: .default) { (_) in
            completion()
        }
        
        alert.addAction(OKAction)
        
        self.present(alert, animated: true, completion: nil)
    }
}
