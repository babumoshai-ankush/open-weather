//
//  ViewController.swift
//  WeAther
//
//  Created by PC-010 on 25/03/22.
//

import UIKit
import CoreLocation

class HomeViewController: BaseViewController {
    
    @IBOutlet weak var collectionViewCityDetails: UICollectionView!
    @IBOutlet weak var pageController: UIPageControl!
    private var cityManager = CityWeatherManager.shared
    var locManager = CLLocationManager()
    private var isLocationFetched = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showLoading(message: "Syncing weather details")
        userLocation()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "seugeListOfSavedWeather" {
            let vcList = segue.destination as? ListOfCitiesViewController
            vcList?.newCityAdded = {
                self.cityManager.fetchAllCityWeather(completion: { isSuccess, error in
                    self.processResponse(error: error)
                })
            }
        }
    }
}

// MARK: - Scroll view delegate
extension HomeViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let xPoint = scrollView.contentOffset.x + scrollView.frame.width / 2
        let yPoint = scrollView.frame.height / 2
        let center = CGPoint(x: xPoint, y: yPoint)
        if let ip = collectionViewCityDetails.indexPathForItem(at: center) {
            pageController.currentPage = ip.row
        }
    }
}

// MARK: - Collection view flow layout delegate

extension HomeViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = UIApplication.shared.windows.filter {$0.isKeyWindow}.first?.safeAreaLayoutGuide.layoutFrame.size
        guard let size = size else {
            return UIScreen.main.bounds.size
        }
        return size
    }
}

// MARK: - Collection view data source

extension HomeViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cityManager.cities.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cellIdentifier = "cellIdentifierCityDetails"
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! CityDetailsCollectionViewCell
        cell.city = cityManager.cities[indexPath.row]
        return cell
    }
}

// MARK: - Button actions

extension HomeViewController {
    @IBAction func buttonInfoOnTap(_ sender: UIButton) {
        UIApplication.shared.open(URL(string: "https://openweathermap.org/")!, options: [:], completionHandler: nil)
    }
}

// MARK: - Private methods

private extension HomeViewController {
    
    func userLocation() {
        locManager.delegate = self
        if CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedWhenInUse || CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedAlways {
            locManager.startUpdatingLocation()
            return
        }
        locManager.requestAlwaysAuthorization()
        locManager.requestWhenInUseAuthorization()
    }
    
    func getAddress(location: CLLocation) {
        CLGeocoder().reverseGeocodeLocation(location, completionHandler: { [unowned self] (placemarks, error) -> Void in
            if let error = error {
                print("Reverse geocoder failed with error" + error.localizedDescription)
                return
            }
            if !(placemarks?.isEmpty ?? true) {
                guard let pm = placemarks?.first else {
                    fatalError("Place not found")
                }
                let addressComponents = [pm.subLocality, pm.locality]
                let address = addressComponents.compactMap { $0 }.joined(separator: ", ")
                getWeatherData(city: address, postalCode: pm.postalCode ?? "N/A", coordinate: location.coordinate)
                return
            }
            print("Problem with the data received from geocoder")
        })
    }
    
    func getWeatherData(city: String, postalCode: String, coordinate: CLLocationCoordinate2D) {
        cityManager.addNewAndFetchAllCityWeather(cityName: city, zipCode: postalCode, coordinate: coordinate, completion: { [unowned self] (isSuccess, error) in
            processResponse(error: error)
        })
    }
    
    func processResponse(error: Error?) {
        if let error = error {
            // TODO: Show error
            return
        }
        pageController.numberOfPages = cityManager.cities.count
        pageController.currentPage = 0
        collectionViewCityDetails.scrollToItem(at:IndexPath(item: 0, section: 0), at: .left, animated: false)
        collectionViewCityDetails.reloadData()
        collectionViewCityDetails.isHidden = false
        hideLoading()
    }
}

// MARK: - CLLocationManagerDelegate

extension HomeViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard !isLocationFetched,
              let location = locations.first else {
                  return
              }
        isLocationFetched = true
        getAddress(location: location)
        manager.stopUpdatingLocation()
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        if CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedWhenInUse || CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedAlways {
            guard let currentLocation = locManager.location else {
                return
            }
            getAddress(location: currentLocation)
        } else {
            // TODO: Request again
        }
    }
}


