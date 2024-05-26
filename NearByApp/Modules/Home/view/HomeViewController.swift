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
    var placeCategory: String?
    var countryOfPlace: String?
    var regionOfPlace: String?
}

@available(iOS 13.0.0, *)
class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var numberOfPlaces = 0
    var homeViewModel: HomeViewModelProtocol?
    var placeDetails: [PlaceDetails] = [PlaceDetails]()
    var indicator : UIActivityIndicatorView?
   
    @IBOutlet weak var btnModeText: UIBarButtonItem!
    @IBOutlet weak var nearLocationsTableView: UITableView!
    @IBOutlet weak var statusImage: UIImageView!
    @IBOutlet weak var statusText: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        homeViewModel = HomeViewModel()
        
        if let mode = UserDefaults.standard.string(forKey: "Mode") {
            btnModeText.title = mode
        }
        
        self.statusImage.isHidden = true
        self.statusText.text = ""
 
        loadingIndicator()
        getUpdatedPlaces()
        checkNetworkReachability()
        updateTableView()
        
        nearLocationsTableView.delegate = self
        nearLocationsTableView.dataSource = self
        
        let nibCustomCell = UINib(nibName: "LocationTableViewCell", bundle: nil)
        nearLocationsTableView.register(nibCustomCell, forCellReuseIdentifier: "LocationTableViewCell")
    }
    
    override func viewDidLayoutSubviews() {
        placeDetails.removeAll()
        print("viewDidLayoutSubviews \(numberOfPlaces)")
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if numberOfPlaces > 0{
            self.indicator?.stopAnimating()
            return numberOfPlaces
        }
        return 0
        
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 130.0
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LocationTableViewCell", for: indexPath) as! LocationTableViewCell

        if (placeDetails.count > indexPath.row){
            let imageUrl = URL(string: (placeDetails[indexPath.row].placeImagePrefix ?? "")+"bg_120"+(placeDetails[indexPath.row].placeImageSuffix ?? ""))
            
            cell.locationIcon.sd_setImage(with: imageUrl, placeholderImage: UIImage(named: "wrong"))
            
            cell.placeName.text = placeDetails[indexPath.row].placeName
            cell.placeCategory.text = placeDetails[indexPath.row].placeCategory
            cell.placeAddress.text = (placeDetails[indexPath.row].countryOfPlace ?? "")+", "+(placeDetails[indexPath.row].regionOfPlace ?? "")
        }
        
        return cell
        
    }
    
    @available(iOS 13.0, *)
    func loadingIndicator(){
        indicator=UIActivityIndicatorView(style: .large)
        guard let indicator = indicator else{
            return
        }
        indicator.center = view.center
        indicator.startAnimating()
        view.addSubview(indicator)
    }
    
    func checkNetworkReachability(){
        homeViewModel?.bindNetworkStatusToViewController = {
            print("homeViewModel No network connection")
            let alertController = UIAlertController(title: "No Internet Connection", message: "Please check your connection and try again", preferredStyle: .alert)

            let okAction = UIAlertAction(title: "OK", style: .default) { _ in }
            alertController.addAction(okAction)

            DispatchQueue.main.async {
                print("DispatchQueue No network connection")
                self.present(alertController, animated: true, completion: nil)
            }
        }
        homeViewModel?.checkNetworkConnection()
    }
    
    @IBAction func btnMode(_ sender: Any) {
        if btnModeText.title == "Realtime"{
            btnModeText.title = "Single"
            UserDefaults.standard.set(btnModeText.title, forKey: "Mode")
        }else{
            getUpdatedPlaces()
            btnModeText.title = "Realtime"
            UserDefaults.standard.set(btnModeText.title, forKey: "Mode")
        }
    }
    
    
    func calculateDistance(fromLatitude latitude1: Double, fromLongitude longitude1: Double, toLatitude latitude2: Double, toLongitude longitude2: Double) -> CLLocationDistance {
        let coordinate1 = CLLocation(latitude: latitude1, longitude: longitude1)
        let coordinate2 = CLLocation(latitude: latitude2, longitude: longitude2)
        
        return coordinate1.distance(from: coordinate2)
    }
    
    
    @available(iOS 13.0.0, *)
    func updateTableView(){
        homeViewModel?.getNearLocationsFromApi()
        homeViewModel?.bindPlacesToViewController = {
            self.numberOfPlaces = self.homeViewModel?.nearLocations?.results.count ?? 10
            self.collectPlacesFromViewModel()
            DispatchQueue.main.async {
                self.nearLocationsTableView.reloadData()
            }
        }
        
    }
    
    func updateBackgroundSubviews(isTableViewHidden: Bool, isStatusImageHidden: Bool, imageName: String, statusText: String){
        self.indicator?.stopAnimating()
        self.nearLocationsTableView.isHidden = isTableViewHidden
        self.statusImage.isHidden = isStatusImageHidden
        self.statusImage.image = UIImage(named: imageName)
        self.statusText.text = statusText
    }
    
    
    func getUpdatedPlaces(){
        LocationManager.shared.getUserLocation{ location in
            self.homeViewModel?.getNearLocationsFromApi()
            self.checkApplicationMode()
            if LocationManager.distance >= 100 {
                self.homeViewModel?.bindPlacesToViewController = {
                    self.numberOfPlaces = self.homeViewModel?.nearLocations?.results.count ?? 10
                    self.collectPlacesFromViewModel()
                    DispatchQueue.main.async {
                        self.nearLocationsTableView.reloadData()
                    }
                    
                }
            }
        }
    }
    
    
    func checkApplicationMode(){
        if (LocationManager.currentLocation?.coordinate.latitude ?? 0 < 0 ) && (self.numberOfPlaces == 0) && (UserDefaults.standard.string(forKey: "GetData") == "success") {
            self.updateBackgroundSubviews(isTableViewHidden: true, isStatusImageHidden: false, imageName: "NoData", statusText: "No data found !!")
            self.view.setNeedsLayout()
        }else if (UserDefaults.standard.string(forKey: "GetData") == "error") || (UserDefaults.standard.string(forKey: "Online") == "false") {
            self.updateBackgroundSubviews(isTableViewHidden: true, isStatusImageHidden: false, imageName: "wrong", statusText: "Somthing went wrong !!")
        }else {
            self.nearLocationsTableView.isHidden = false
            self.statusImage.isHidden = true
            self.statusText.text = ""
            if LocationManager.distance >= 500 {
                self.view.setNeedsLayout()
            }
        }
    }
    
    
    func collectPlacesFromViewModel(){
        var placeDetails = PlaceDetails()
        for i in 0..<self.numberOfPlaces {
            if self.homeViewModel?.nearLocations?.results[i].categories.count ?? 0 > 0 {
                placeDetails.placeName = self.homeViewModel?.nearLocations?.results[i].name ?? ""
                placeDetails.placeImagePrefix = self.homeViewModel?.nearLocations?.results[i].categories[0].icon?.prefix ?? ""
                placeDetails.placeImageSuffix = self.homeViewModel?.nearLocations?.results[i].categories[0].icon?.suffix ?? ""
                
                placeDetails.placeCategory = self.homeViewModel?.nearLocations?.results[i].categories[0].plural_name
                placeDetails.countryOfPlace = self.homeViewModel?.nearLocations?.results[i].location?.country
                placeDetails.regionOfPlace = self.homeViewModel?.nearLocations?.results[i].location?.region
                
                self.placeDetails.append(placeDetails)
            }
        }
        UserDefaults.standard.set("success", forKey: "GetData")
    }
    
}

