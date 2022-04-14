//
//  ViewController.swift
//  ApiRequest
//
//  Created by Neha Gupta on 31/07/21.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let dataModel = DataModel()
        dataModel.registerUserWithEncodableProtocol()
    }


}

