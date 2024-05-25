//
//  ViewController.swift
//  NearByApp
//
//  Created by Mina Emad on 21/05/2024.
//

import UIKit
import SDWebImage
import CoreLocation


@available(iOS 13.0.0, *)
class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet weak var nearLocationsTableView: UITableView!
    
    var homeViewModel: HomeViewModelProtocol?
    var numberOfPlaces = 0
    var networkConnection: NetworkConnection?
    var placeDetails: [PlaceDetails] = [PlaceDetails]()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        networkConnection = NetworkConnection()
        homeViewModel = HomeViewModel()
        
        getUpdatedLocation()
        checkNetworkConnection()
        updateTableView()
        
        
        nearLocationsTableView.delegate = self
        nearLocationsTableView.dataSource = self
        
        let nibCustomCell = UINib(nibName: "LocationTableViewCell", bundle: nil)
        nearLocationsTableView.register(nibCustomCell, forCellReuseIdentifier: "locationCell")
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return numberOfPlaces
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return 200.0
        }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "locationCell", for: indexPath) as! LocationTableViewCell

        if placeDetails.count > 0{
            let imageUrl = URL(string: (placeDetails[indexPath.row].placeImagePrefix ?? "")+"bg_120"+(placeDetails[indexPath.row].placeImageSuffix ?? ""))
            
            cell.locationIcon.sd_setImage(with: imageUrl, placeholderImage: UIImage(named: "man"))
            
            cell.placeName.text = placeDetails[indexPath.row].placeName
            cell.placeCategory.text = placeDetails[indexPath.row].categoryOfPlace?.plural_name
            cell.placeAddress.text = (placeDetails[indexPath.row].countryOfPlace ?? "")+", "+(placeDetails[indexPath.row].regionOfPlace ?? "")
        }
        

        return cell
        
    }
    
    
    
    @available(iOS 13.0.0, *)
    func updateTableView(){

        homeViewModel?.getNearLocationsFromApi()
        
        homeViewModel?.bindResultToViewController = {
            self.numberOfPlaces = self.homeViewModel?.nearLocations?.results.count ?? 10
            print("numberOfPlaces : \(self.numberOfPlaces)")
            var placeDetails = PlaceDetails()
            for i in 0..<self.numberOfPlaces {
                placeDetails.placeName = self.homeViewModel?.nearLocations?.results[i].name ?? ""
                placeDetails.placeImagePrefix = self.homeViewModel?.nearLocations?.results[i].categories[0].icon?.prefix ?? ""
                placeDetails.placeImageSuffix = self.homeViewModel?.nearLocations?.results[i].categories[0].icon?.suffix ?? ""
                
                placeDetails.categoryOfPlace = self.homeViewModel?.nearLocations?.results[i].categories[0]
                placeDetails.countryOfPlace = self.homeViewModel?.nearLocations?.results[i].location?.country
                placeDetails.regionOfPlace = self.homeViewModel?.nearLocations?.results[i].location?.region
                
                self.placeDetails.append(placeDetails)
            }
            
            
            DispatchQueue.main.async {
                self.nearLocationsTableView.reloadData()
            }
        }
        
    }
    
    func getUpdatedLocation(){
        LocationManager.shared.getUserLocation{ location in
            
            if LocationManager.distance >= 200 {
                print("if distance")
                self.homeViewModel?.getNearLocationsFromApi()
                
                self.homeViewModel?.bindResultToViewController = {
                    self.numberOfPlaces = self.homeViewModel?.nearLocations?.results.count ?? 10
                    print("numberOfPlaces : \(self.numberOfPlaces)")
                    var placeDetails = PlaceDetails()
                    for i in 0..<self.numberOfPlaces {
                        if self.homeViewModel?.nearLocations?.results[i].categories.count ?? 0 > 0 {
                        
                            placeDetails.placeName = self.homeViewModel?.nearLocations?.results[i].name ?? ""
                            placeDetails.placeImagePrefix = self.homeViewModel?.nearLocations?.results[i].categories[0].icon?.prefix ?? ""
                            placeDetails.placeImageSuffix = self.homeViewModel?.nearLocations?.results[i].categories[0].icon?.suffix ?? ""
                            
                            placeDetails.categoryOfPlace = self.homeViewModel?.nearLocations?.results[i].categories[0]
                            placeDetails.countryOfPlace = self.homeViewModel?.nearLocations?.results[i].location?.country
                            placeDetails.regionOfPlace = self.homeViewModel?.nearLocations?.results[i].location?.region
                            
                            self.placeDetails.append(placeDetails)
                        }
                       
                    }
                    
                    
                    
                    DispatchQueue.main.async {
                        self.nearLocationsTableView.reloadData()
                    }
                }
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


struct PlaceDetails{
    var placeName: String?
    var placeImagePrefix: String?
    var placeImageSuffix: String?
    var categoryOfPlace: CategoryOfLacation?
    var countryOfPlace: String?
    var regionOfPlace: String?
}
