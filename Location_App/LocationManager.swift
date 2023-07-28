//
//  LocationManager.swift
//  Location_App
//
//  Created by Designer on 2023/07/13.
//

import Foundation
import CoreLocation

class LocationManager: NSObject {
    
    override init() {
        super.init()
        manager.delegate = self
        manager.requestWhenInUseAuthorization()
    }
    
    var manager = CLLocationManager()
    
    var completion: ((CLLocation) -> Void)?
    
    func getMyLocation(completion:@escaping (CLLocation) -> Void) {
        self.completion = completion
        // 권한을 부여받을지 물어봐야한다.
//        manager.requestWhenInUseAuthorization()
        // 위치를 업데이트한다.
//        manager.startUpdatingLocation()
        // 위치를 받지 않는다.
//        manager.stopUpdatingLocation()
        
    }
    
}

extension LocationManager: CLLocationManagerDelegate {
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .authorizedWhenInUse: // 앱을 사용하는동안 사용한다는 뜻
            // 내 위치 정보를 가져온다
            manager.startUpdatingLocation()
        case .notDetermined: // 물어보지 않았다
            manager.requestWhenInUseAuthorization()
        case .restricted: // 사용자가 안되는 지역일때 제한된 구역
            break
        case .denied: // 거부했을때
            manager.stopUpdatingLocation()
        case .authorizedAlways: // 항상 사용한다는 뜻
            break
        @unknown default:
            fatalError()
        }
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else {
            return
        }
        self.completion?(location)
    }
}
