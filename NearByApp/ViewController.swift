//
//  ViewController.swift
//  NearByApp
//
//  Created by Mina Emad on 21/05/2024.
//

import UIKit
import SDWebImage

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet weak var nearLocationsTableView: UITableView!
    
    var fetchDataFromAPI: FetchDataFromAPI?
        
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchDataFromAPI = FetchDataFromAPI()
        if #available(iOS 13.0, *) {
            Task {
                await fetchDataFromAPI?.getNearLocations()
            }
        }
        nearLocationsTableView.delegate = self
        nearLocationsTableView.dataSource = self
        let nibCustomCell = UINib(nibName: "LocationTableViewCell", bundle: nil)
        nearLocationsTableView.register(nibCustomCell, forCellReuseIdentifier: "locationCell")
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            // Return the desired height for your custom cell
            return 200.0 // Change this value to your desired height
        }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "locationCell", for: indexPath) as! LocationTableViewCell
        
        //https://ss3.4sqi.net/img/categories_v2/building/default_120.png
        //https://ss3.4sqi.net/img/categories_v2/nightlife/hookahbar_120.png
        
        //https://totalpng.com//public/uploads/preview/joker-png-download-116534606012m0ndj8vdf.png
        
        let imageUrl = URL(string: "https://totalpng.com//public/uploads/preview/joker-png-download-116534606012m0ndj8vdf.png")
        
        cell.locationIcon.sd_setImage(with: imageUrl, placeholderImage: UIImage(named: "man"))
        
        cell.placeName.text = "Caffee"
        cell.placeCategory.text = "Caffee Shop"
        cell.placeAddress.text = "Cairo"
        return cell
        
    }

}

