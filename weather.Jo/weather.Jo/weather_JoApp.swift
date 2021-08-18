//
//  weather_JoApp.swift
//  weather.Jo
//
//  Created by admin on 2021/8/13.
//

import SwiftUI

@main
struct weather_JoApp: App {
    let persistenceController = PersistenceController.shared

    @StateObject var shareData = getData()
    var body: some Scene {
        WindowGroup {
            
            mainPage()
                    .environment(\.managedObjectContext, persistenceController.container.viewContext).environmentObject(shareData)
            
            
       }
    }
}
