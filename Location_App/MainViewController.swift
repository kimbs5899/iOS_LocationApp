//
//  ViewController.swift
//  Location_App
//
//  Created by Designer on 2023/07/11.
//

import UIKit
import MapKit

class MainViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    
    var searchController: UISearchController!
    var resultController: SearchResultTableViewController!
    var filteredLandmarks = [PinLandmark]()
    let locationManager = LocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "LandMark"
        self.hideKeyboardWhenTappedAround()
        mapView.delegate = self
        
        addPin()
        
        makeResultController()
        makeSearchController()
        
        locationManager.getMyLocation { location in
            self.moveMapToLocation(location.coordinate)
        }
    }
    
    func moveMapToLocation(_ coordinate: CLLocationCoordinate2D) {
        // 받은 location정보 위치로 이동
        let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        let region = MKCoordinateRegion(center: coordinate, span: span)
        mapView.setRegion(region, animated: true)
        mapView.showsUserLocation = true
    }

    private func makeResultController() {
        resultController = self.storyboard?.instantiateViewController(identifier: "SearchResultTableViewController") as? SearchResultTableViewController
        resultController.tableView.delegate = self
        resultController.tableView.dataSource = self
    }
    
    private func makeSearchController() {
        searchController = UISearchController(searchResultsController: resultController)
        searchController.searchResultsUpdater = self
        searchController.searchBar.autocapitalizationType = .none
        navigationItem.searchController = searchController
    }
    
    private func addPin() {
        PinLandmark.allCases.forEach { landmark in
            let pin = MyPointAnnotation()
            pin.title = landmark.title
            pin.coordinate = landmark.cordinate
            pin.id = landmark.id
            self.mapView.addAnnotation(pin)
        }
    }
}

extension MainViewController:MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        
        // type casting
        guard let hasView = view.annotation as? MyPointAnnotation else {
            return
        }
        let selectPin = PinLandmark(rawValue: hasView.id)
        
        // move to detailVC
        let detailVC = self.storyboard?.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
        detailVC.url = selectPin?.url
        self.navigationItem.title = selectPin?.title
        self.navigationController?.pushViewController(detailVC, animated: true)
        
        self.mapView.deselectAnnotation(view.annotation, animated: true)
    }
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dissmissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    @objc func dissmissKeyboard() {
        view.endEditing(true)
    }
}

extension MainViewController: UITableViewDelegate, UITableViewDataSource, UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let searchText = searchController.searchBar.text ?? ""
        let pinAllList = PinLandmark.allCases
        
        filteredLandmarks = pinAllList.filter{ landmark in
//            landmark.title.contains(searchText)
            landmark.title.lowercased().contains(searchText.lowercased())
        }
        resultController.tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredLandmarks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ResultCell", for: indexPath) as! ResultCell
        
        cell.title.text = filteredLandmarks[indexPath.row].title
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let selectedPin = PinLandmark(rawValue: filteredLandmarks[indexPath.row].id) else {
            return
        }
        
        let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        let regian = MKCoordinateRegion(center: selectedPin.cordinate, span: span)
        self.mapView.setRegion(regian, animated: true)
        searchController.isActive = false
         
        self.navigationItem.title = selectedPin.title
    }
}
class MyPointAnnotation: MKPointAnnotation {
    var id = 0
}
