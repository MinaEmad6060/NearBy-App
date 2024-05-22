//
//  ViewController.swift
//  NearByApp
//
//  Created by Mina Emad on 21/05/2024.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet weak var nearLocationsTableView: UITableView!
    
        
    override func viewDidLoad() {
        super.viewDidLoad()
        nearLocationsTableView.delegate = self
        nearLocationsTableView.dataSource = self
        // Do any additional setup after loading the view.
//        let nibCustomCell = UINib(nibName: "CustomTableViewCell", bundle: nil)
//        tableViewNib.register(nibCustomCell, forCellReuseIdentifier: "customCell")
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "locationCell", for: indexPath)
//        as! CustomTableViewCell
        
        cell.textLabel?.text = "hello"
        
        
        return cell
    }


}

