//
//  locationManager.swift
//  weather.Jo
//
//  Created by admin on 2021/8/15.
//

import Foundation
import CoreLocation

class locationManager  {
    static let shared = locationManager()
    
    let manager = CLLocationManager()
    

    func getUserLocationAutherization() ->Bool{
        var isAutherized = false
        
        // send request to the user to get the premission
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
        
        // getting the user answer
        let autherizationStatus = manager.authorizationStatus
        
        
        
        switch autherizationStatus {
        case .authorizedAlways:
            isAutherized = true
        case .authorizedWhenInUse:
            isAutherized = true
        case .denied:
            isAutherized = false
        case .notDetermined:
            isAutherized = false
        case .restricted:
            isAutherized = false
        default:
            isAutherized = false
        }
        
        
        return isAutherized
    }
    func getLocationCoordinate()->(latitude:Double,longitude:Double){
        return (Double(manager.location?.coordinate.latitude ?? 21.27),Double(manager.location?.coordinate.longitude ?? 39.49))
    }
    
}
