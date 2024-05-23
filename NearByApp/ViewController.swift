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
    var nearByLocations: NearByLocations?
        
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchDataFromAPI = FetchDataFromAPI()
        nearByLocations = NearByLocations()
        if #available(iOS 13.0, *) {
            Task {
                    nearByLocations = await fetchDataFromAPI?.getNearLocations()
                    DispatchQueue.main.async {
                        self.nearLocationsTableView.reloadData() // Update table view
                    }
            }
        }
        nearLocationsTableView.delegate = self
        nearLocationsTableView.dataSource = self
        let nibCustomCell = UINib(nibName: "LocationTableViewCell", bundle: nil)
        nearLocationsTableView.register(nibCustomCell, forCellReuseIdentifier: "locationCell")
    }
    
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return nearByLocations?.results.count ?? 10
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            // Return the desired height for your custom cell
            return 200.0 // Change this value to your desired height
        }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "locationCell", for: indexPath) as! LocationTableViewCell
        
        let imageUrl = URL(string: "https://ss3.4sqi.net/img/categories_v2/nightlife/hookahbar_bg_120.png")
        
        cell.locationIcon.sd_setImage(with: imageUrl, placeholderImage: UIImage(named: "man"))
        
        cell.placeName.text = nearByLocations?.results[indexPath.row].name
        cell.placeCategory.text = nearByLocations?.results[indexPath.row].categories[0].plural_name
        cell.placeAddress.text = nearByLocations?.results[indexPath.row].location?.country
        return cell
        
    }

}

