//
//  searchingView.swift
//  weather.Jo
//
//  Created by admin on 2021/8/15.
//

import SwiftUI
import CoreData

struct searchingView: View {
    @Environment(\.presentationMode) var mode
    @State var cancel = false
    @EnvironmentObject var userdata:getData
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(entity: City.entity(), sortDescriptors: []) var cities:FetchedResults<City>
    var body: some View {
        VStack(spacing:0){
            searchingBar(cancel: $cancel)
            ScrollView(showsIndicators: false){
                
                if userdata.citiesList.count > 0 {
                    ForEach(userdata.citiesList.filter{
                        $0.name.contains(userdata.searchingContent)
                    },id:\.name){ item in
                                HStack{
                                    Text(item.name)
                                        .padding(.leading).foregroundColor(.black)
                                    Spacer()
                                }.padding()
                                .onTapGesture {
                                    userdata.getDataFor(lon: item.latlng[0], lad: item.latlng[1])
                                    
                                    
                                    addNewCity(city: item)
                                    
                                    mode.wrappedValue.dismiss()
                                    
                                    
                                    userdata.searchingContent = ""
                                    
                                }

                    }
                    .background(Color(.darkGray))
                    .ignoresSafeArea()

                }
                
                
            }.background(Color(.darkGray))
            .opacity(0.3)
            .ignoresSafeArea()
        }
    }
    func addNewCity(city:cityDataType){
        for i in cities {
            if i.name == city.name {
                return
            }
          }
            let newCity = City(context: moc)
            newCity.name = city.name
            newCity.lat = city.latlng[0]
            newCity.long = city.latlng[1]
            newCity.timeZone = city.timezones[0]
            do {
                try moc.save()
            }catch{
                print(error)
            }
      
    }
}

struct searchingView_Previews: PreviewProvider {
    static var previews: some View {
        searchingView()
    }
}
struct searchingBar:View{
    @Binding var cancel:Bool
    @Environment(\.presentationMode) var mode
    @EnvironmentObject var userdata:getData
    var body: some View{
        ZStack(alignment:.center){
            Rectangle()
                .foregroundColor(Color(.darkGray))
                .frame(width: UIScreen.main.bounds.width, height: 90)
            VStack(spacing:10){
                Text("Enter city or country name")
            HStack{
                ZStack(alignment:.leading){
                    TextField("searc here....", text: $userdata.searchingContent)
                        .frame(width: UIScreen.main.bounds.width-140, height: 40, alignment: .leading).padding(.leading,40)
                        .background(Color(.lightGray))
                        .cornerRadius(10)
                        .font(.headline)
                        .padding(.leading)
                    
                    Image(systemName: "magnifyingglass")
                        .resizable()
                        .frame(width: 20, height: 20)
                        .padding(.leading,24)

                }
            Button(action: {cancel = true
                mode.wrappedValue.dismiss()
            }, label: {
                Text("Cancel")
                    .foregroundColor(.white)
                    .padding(.trailing)

            })
            }
          }
            
        }

    }
}

