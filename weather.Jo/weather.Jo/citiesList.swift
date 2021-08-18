//  citiesList.swift
//  weather.Jo
//  Created by admin on 2021/8/14.

import SwiftUI
import CoreData

struct citiesList: View {
    @EnvironmentObject var userdata:getData
    @State var showSearchBar = false
    @FetchRequest(entity: City.entity(), sortDescriptors: []) var cities:FetchedResults<City>
    @Environment(\.managedObjectContext) var moc

    var body: some View {
        VStack(spacing:0){
            ZStack(alignment: .bottom){
                ScrollView(showsIndicators: false){
                
                if userdata.Data.count > 0 {
                    listItem(cityName: userdata.currentCity, degree: String(Int(userdata.Data[0].current.temp)),icon: userdata.Data[0].current.weather[0].icon).padding(.bottom,-18)

                        
                        .background(userdata.isDay() == true ? Color("collect2-c"):Color("collect1-c"))
                        .onTapGesture {
                            userdata.backToMain = true
                            userdata.goToList = false
                            userdata.citiesIndex = 0
                            userdata.lat = 0
                            userdata.long = 0
                            userdata.locationTimeZone = "current"
                            userdata.isCurrent = true
                        }
                    
                    ForEach(Array(cities.enumerated()),id:\.element){ index,city in

                        if  userdata.Data.count != 1 && userdata.Data.count-1 >= index{
                            listItem(cityName: city.name!, degree: String(Int(userdata.Data[index+1].current.temp)),index: index, icon:userdata.Data[index+1].current.weather[0].icon)
                                .padding(.bottom,-18)
                            .onTapGesture {
                            userdata.locationName = city.name!
                            userdata.backToMain = true
                            userdata.goToList = false
                            userdata.citiesIndex = index+1
                            userdata.lat = city.lat
                            userdata.long = city.long
                            userdata.locationTimeZone = city.timeZone!
                            userdata.isCurrent = false
                        }
                            
                                                            
                            
                            
                        }
                    }.padding(0)
                  
                }
                                
            }.padding(.bottom,70)
            .padding(.top,40)
            
                addingBar()
                    .sheet(isPresented: $userdata.showSheet, content: {
                        searchingView()
                            .environmentObject(userdata)
                            .environment(\.managedObjectContext, self.moc)
                    })
            }.padding(0)
            .ignoresSafeArea(.all, edges: .bottom)
            
        }
        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        .background(Color.black)
    }

}

struct citiesList_Previews: PreviewProvider {
    static var previews: some View {
        citiesList()
    }
}
struct listItem:View{
    @State var cityName = ""
    @State var degree = ""
    @State var index = 0
    @State var icon = ""
    @EnvironmentObject var userdata:getData
    var body: some View{
        HStack(alignment:.lastTextBaseline){
                Text("\(cityName)")
                    .font(.title2)
                    .padding(.leading)
                
                Spacer()
            
            
            LottieView(name: getIcon(icon: icon), loopMode: .loop)
                .frame(width: 80, height: 80)
                Text("\(degree)º").font(.custom("", size: 60)).padding(.trailing)

        }
        .frame(height: 90)
        .background(icon.contains("d") ? Color("collect2-c"):Color("collect1-c"))

        

    }

}
struct addingBar:View{
    @EnvironmentObject var userdata:getData
    var body: some View{
        HStack{
            Spacer()
            Button(action: {userdata.showSheet = true}, label: {
                Image(systemName: "plus.circle")
                    .resizable()
                    .frame(width: 30, height: 30)
                    .padding(.trailing)
                    .foregroundColor(.white)
            })

            
        }.frame(width: UIScreen.main.bounds.width, height: 80)
        .background(Color(.darkGray))
        .ignoresSafeArea()
    }
}
