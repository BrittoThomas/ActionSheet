//
//  ViewController.swift
//  ActionSheet
//
//  Created by Britto Thomas on 01/10/19.
//  Copyright © 2019 Britto Thomas. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func buttonActionShow(_ sender: Any) {
        let actionSheet = ActionSheetViewController.init()
        actionSheet.show()
    }

}

