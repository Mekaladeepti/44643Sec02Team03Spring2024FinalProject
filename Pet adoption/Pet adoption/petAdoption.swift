//
//  ViewController.swift
//  Pet adoption
//
//  Created by MekalaDeepthi on 2/22/24.
//

import UIKit

class petAdoption: UIViewController {
    
    @IBOutlet weak var petTV: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        petTV.text = "Browse through a wide range of healthy pets that perfectly matches"
    }


}

