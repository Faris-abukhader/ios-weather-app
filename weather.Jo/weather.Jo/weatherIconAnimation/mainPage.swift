//
//  mainPage.swift
//  weather.Jo
//
//  Created by admin on 2021/8/15.
//

import SwiftUI

struct mainPage: View {
    @EnvironmentObject var userdata:getData
    var body: some View {
        if userdata.goToList {
            citiesList().environmentObject(userdata)
        } else {
            ContentView()
                .environmentObject(userdata)
        }
    }
}

struct mainPage_Previews: PreviewProvider {
    static var previews: some View {
        mainPage()
    }
}
