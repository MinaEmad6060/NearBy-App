//
//  ViewController.swift
//  NearByApp
//
//  Created by Mina Emad on 21/05/2024.
//

import UIKit
import SDWebImage
import CoreLocation

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet weak var nearLocationsTableView: UITableView!
    
    var fetchDataFromAPI: FetchDataFromAPI?
    var nearByLocations: NearByLocations?
    var networkConnection: NetworkConnection?
        
    override func viewDidLoad() {
        super.viewDidLoad()
        networkConnection = NetworkConnection()
        checkNetworkConnection()
        getUpdatedLocation()
        fetchDataFromAPI = FetchDataFromAPI()
        nearByLocations = NearByLocations()
        if #available(iOS 13.0, *) {
            Task {
                    nearByLocations = await fetchDataFromAPI?.getNearLocations()
                    DispatchQueue.main.async {
                        self.nearLocationsTableView.reloadData()
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
        if let nearByLocations = nearByLocations {
            if !nearByLocations.results[indexPath.row].categories.isEmpty {
                let imageUrl = URL(string: (nearByLocations.results[indexPath.row].categories[0].icon?.prefix ?? "")+"bg_120"+(nearByLocations.results[indexPath.row].categories[0].icon?.suffix ?? ""))
                
                cell.locationIcon.sd_setImage(with: imageUrl, placeholderImage: UIImage(named: "man"))
                
                cell.placeName.text = nearByLocations.results[indexPath.row].name
                cell.placeCategory.text = nearByLocations.results[indexPath.row].categories[0].plural_name
                cell.placeAddress.text = (nearByLocations.results[indexPath.row].location?.country ?? "")+", "+(nearByLocations.results[indexPath.row].location?.region ?? "")
            }
        }
        return cell
        
    }
    
    
    func getUpdatedLocation(){
        LocationManager.shared.getUserLocation{ location in
            
            if LocationManager.distance >= 200 {
                print("if distance")
                if #available(iOS 13.0, *) {
                    print("if #available")
                    Task {
                        print("Task")
                        self.nearByLocations = await self.fetchDataFromAPI?.getNearLocations()
                        if let nearByLocations = self.nearByLocations {
                            print("New Area : \(nearByLocations.results.count)")
                            print("New Area : \(nearByLocations.results[0].name ?? "none")")
                        }
                        DispatchQueue.main.async {
                            print("DispatchQueue")
                            self.nearLocationsTableView.reloadData()
                        }
                    }
                }
                print("Reset")
            }else {
                print("Distance is less than 200")
            }
            
            print("Distance: \(LocationManager.distance) meters")
        }
        
    }
    
    
    func calculateDistance(fromLatitude latitude1: Double, fromLongitude longitude1: Double, toLatitude latitude2: Double, toLongitude longitude2: Double) -> CLLocationDistance {
        let coordinate1 = CLLocation(latitude: latitude1, longitude: longitude1)
        let coordinate2 = CLLocation(latitude: latitude2, longitude: longitude2)
        
        return coordinate1.distance(from: coordinate2)
    }
    
    func checkNetworkConnection(){
        if networkConnection!.isNetworkReachable() {
            print("Network is reachable")
        } else {
            let alertController = UIAlertController(title: "Alert Title", message: "Alert Message", preferredStyle: .alert)

            let okAction = UIAlertAction(title: "OK", style: .default) { _ in
                // Handle OK button action if needed
            }
            alertController.addAction(okAction)

            // Present the alert
            DispatchQueue.main.async {
                self.present(alertController, animated: true, completion: nil)
            }
            print("No network connection")
        }
    }
 

}

