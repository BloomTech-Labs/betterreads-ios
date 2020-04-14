//
//  SearchTableViewController.swift
//  Readrr
//
//  Created by Alexander Supe on 4/14/20.
//  Copyright © 2020 Alexander Supe. All rights reserved.
//

import UIKit

class SearchTableViewController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // 3
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(updateTableView),
                                               name: .updateEmbeddedTVC,
                                               object: nil)
    }
    
    // Called when notification is heard
    @objc func updateTableView() {
        print("updatingTVC")
        tableView.reloadData()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1 // Change later?
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myBooksArray.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "resultCell", for: indexPath)
        
        cell.textLabel?.text = myBooksArray[indexPath.row]

        return cell
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }

}

let fakeBooksArray = ["Harry Potter", "Twilight", "Animal Farm", "1984", "Metamorphosis", "50 Shades of Gray",
                        "Resident Evil", "Jumanji", "The Bible", "The Maze Runner", "Fahrenheit 451"]
var myBooksArray = [String]()
