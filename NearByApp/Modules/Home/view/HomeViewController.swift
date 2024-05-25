//
//  ViewController.swift
//  NearByApp
//
//  Created by Mina Emad on 21/05/2024.
//

import UIKit
import SDWebImage
import CoreLocation



struct PlaceDetails{
    var placeName: String?
    var placeImagePrefix: String?
    var placeImageSuffix: String?
    var categoryOfPlace: CategoryOfLacation?
    var countryOfPlace: String?
    var regionOfPlace: String?
}


@available(iOS 13.0.0, *)
class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    var numberOfPlaces = 0
    var homeViewModel: HomeViewModelProtocol?
    var placeDetails: [PlaceDetails] = [PlaceDetails]()
        

    @IBAction func btnMode(_ sender: Any) {
        if btnModeText.title == "Realtime"{
            btnModeText.title = "SingleUpdate"
            UserDefaults.standard.set(btnModeText.title, forKey: "Mode")
        }else{
            getUpdatedLocation()
            btnModeText.title = "Realtime"
            UserDefaults.standard.set(btnModeText.title, forKey: "Mode")
        }
    }
    
    @IBOutlet weak var btnModeText: UIBarButtonItem!
    @IBOutlet weak var nearLocationsTableView: UITableView!
    
    
    @IBOutlet weak var statusImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        if let mode = UserDefaults.standard.string(forKey: "Mode") {
            btnModeText.title = mode
        }
        
        
        
        homeViewModel = HomeViewModel()
        
        getUpdatedLocation()
        checkNetworkReachability()
        updateTableView()
        
        
        nearLocationsTableView.delegate = self
        nearLocationsTableView.dataSource = self
        
        let nibCustomCell = UINib(nibName: "LocationTableViewCell", bundle: nil)
        nearLocationsTableView.register(nibCustomCell, forCellReuseIdentifier: "locationCell")
    }
    
    override func viewDidLayoutSubviews() {
        placeDetails.removeAll()
        print("viewDidLayoutSubviews \(numberOfPlaces)")
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
        
        homeViewModel?.bindPlacesToViewController = {
            self.numberOfPlaces = self.homeViewModel?.nearLocations?.results.count ?? 10
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
    
    func getUpdatedLocation(){
        LocationManager.shared.getUserLocation{ location in
                self.homeViewModel?.getNearLocationsFromApi()
//            print("LocationManager : \(UserDefaults.standard.string(forKey: "Online") ?? "nothing")")
            
            if (LocationManager.currentLocation?.coordinate.latitude == -1 || self.numberOfPlaces == 0) && (UserDefaults.standard.string(forKey: "Online") == "success") {
                self.nearLocationsTableView.isHidden = true
                self.statusImage.isHidden = false
                self.statusImage.image = UIImage(named: "joker")
                self.view.setNeedsLayout()
                self.view.layoutIfNeeded()
                self.view.setNeedsDisplay()
            }else if (UserDefaults.standard.string(forKey: "Online") == "error") || (UserDefaults.standard.string(forKey: "Online") == "false") {
                self.statusImage.isHidden = false
                self.statusImage.image = UIImage(named: "man")
            }else {
                self.nearLocationsTableView.isHidden = false
                self.statusImage.isHidden = true
                self.view.setNeedsLayout()
                self.view.layoutIfNeeded()
                self.view.setNeedsDisplay()
            }
                if LocationManager.distance >= 200 {
                    self.homeViewModel?.bindPlacesToViewController = {
                    self.numberOfPlaces = self.homeViewModel?.nearLocations?.results.count ?? 10
//                    print("numberOfPlaces : \(self.numberOfPlaces)")
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
            
//            print("Distance: \(LocationManager.distance) meters")
        }
        
    }
    
    
    func calculateDistance(fromLatitude latitude1: Double, fromLongitude longitude1: Double, toLatitude latitude2: Double, toLongitude longitude2: Double) -> CLLocationDistance {
        let coordinate1 = CLLocation(latitude: latitude1, longitude: longitude1)
        let coordinate2 = CLLocation(latitude: latitude2, longitude: longitude2)
        
        return coordinate1.distance(from: coordinate2)
    }
    
    func checkNetworkReachability(){
        homeViewModel?.bindNetworkStatusToViewController = {
            print("homeViewModel No network connection")
            let alertController = UIAlertController(title: "Alert Title", message: "Alert Message", preferredStyle: .alert)

            let okAction = UIAlertAction(title: "OK", style: .default) { _ in
                // Handle OK button action if needed
            }
            alertController.addAction(okAction)

            // Present the alert
            DispatchQueue.main.async {
                print("DispatchQueue No network connection")
                self.present(alertController, animated: true, completion: nil)
            }
        }
        homeViewModel?.checkNetworkConnection()
    }
    
}

