//
//  LibraryViewController.swift
//  Readrr
//
//  Created by Alexander Supe on 4/16/20.
//  Copyright © 2020 Alexander Supe. All rights reserved.
//

import UIKit

class LibraryViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        performSegue(withIdentifier: "authenticate", sender: nil)
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
