//
//  getData.swift
//  weather.Jo
//
//  Created by admin on 2021/8/14.
//

import Foundation
import LocalAuthentication
import CoreLocation
import Foundation
import CoreData

class getData:ObservableObject {
    
    
    @Published var goToList = false
    @Published var backToMain = false
    @Published var Data:[DataStructure] = []
    @Published var data:[DataStructure] = []
    @Published var locationName = ""
    @Published var locationTimeZone = "current"
    @Published var isCurrent = true
    @Published var currentCity = ""
    @Published var citiesList:[cityDataType] = []
    @Published var citiesIndex = 0
    @Published var showSheet = false
    @Published var searchingContent = ""
    @Published var lat:Double = 0
    @Published var long:Double = 0

     init() {
        if locationManager.shared.getUserLocationAutherization() {
            
            
            
            getDataFor(lon: locationManager.shared.getLocationCoordinate().longitude, lad: locationManager.shared.getLocationCoordinate().latitude)
            getCountriesList()
            getlocality()

        }
        

        
    }
    
    func getDataFor(lon:Double,lad:Double) {
  
        
        let urlString =
        "https://api.openweathermap.org/data/2.5/onecall?lat=\(lad)&lon=\(lon)&exclude=minutely&units=metric&appid={Enter your key here}"
            
        let url = URL(string: urlString)
        
        URLSession.shared.dataTask(with: url!){data,_,error in
            DispatchQueue.main.async {
                if let data = data {
                do{
                    let decoder = JSONDecoder()
                    let decoderData = try decoder.decode(DataStructure.self, from: data)
                    

                    self.Data.append(decoderData)
                    

                }catch{
                    print(error)
                }
              }
            }
        }.resume()


    }

    
    
    func getCountriesList(){
        guard let path = Bundle.main.url(forResource: "countriesList", withExtension: "json") else {return }
        
        do {
            let data = try Foundation.Data(contentsOf: path)
            let fetchedData = try JSONDecoder().decode([cityDataType].self, from: data)
            self.citiesList = fetchedData

        } catch {
            print(error)
        }
    }
    
    func isDay()->Bool{
        let dt = Int(self.Data[0].current.dt) ,
            sunrise = (self.Data[0].current.sunrise), sunset =  self.Data[0].current.sunset
        if dt < sunrise! && dt < sunset! {
            return false
        }else if dt > sunrise! && dt < sunset! {
            return true
        }else{
            return false
        }
        
    }
    
    
    func getlocality(){
        
        if !self.isCurrent {
            return
        }
        let lat = locationManager.shared.getLocationCoordinate().latitude
        let long = locationManager.shared.getLocationCoordinate().longitude
        
        CLGeocoder().reverseGeocodeLocation(CLLocation(latitude: Double(lat), longitude: Double(long)), completionHandler: { (placemarks, error) -> Void in
            if error != nil {
                print("error here")
                return
            }else {
                let pm = placemarks![0]
                if let city = pm.locality {
                    self.currentCity = city
                    
                }
                
            }
        })
    }



    
}


