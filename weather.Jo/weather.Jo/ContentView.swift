//  ContentView.swift
//  weather.Jo
//  Created by admin on 2021/8/13.

import SwiftUI
import CoreData


struct ContentView: View {
    
    @State var cityName = ""
    
    let width = UIScreen.main.bounds.width
    let height = UIScreen.main.bounds.height
    
    @State var mainInfoOffset:CGFloat = 0
 
    let lottieFileName = ["loading","cloudynight","foggy","mist","night","partly-cloudy","partly-shower","rainynight","snow-sunny","snow","snownight","storm","stormshowersday","sunny","thunder"]
    
    
    @State var showLoading = false
    
    @EnvironmentObject var userdata:getData
    
    
    @FetchRequest(entity: City.entity(), sortDescriptors: []) var cities:FetchedResults<City>
    
    let timer = Timer.publish(every: 1.0, on: .main, in: .common).autoconnect()
    @State var threeSecond = 3

        
    var body: some View {
        ZStack{
        if userdata.Data.count > 0 && threeSecond == 0 {
        VStack(spacing:0){
            ZStack(alignment:.bottom){
            ScrollView(showsIndicators: false){
                            
                    
                ZStack{
                    LottieView(name:getIcon(icon: userdata.Data[userdata.citiesIndex].current.weather[0].icon) , loopMode:.loop)
                        .frame(width: 200, height: 200)
                        .offset(x: -60)
                        .opacity(0.7)
                    
                    
                    headMainInfo(cityName: userdata.isCurrent ? userdata.currentCity:userdata.locationName)
                        .padding(.top,height/8)
                    


                }
                
            
                hourDegreeScrollView()
                    .padding(.top,40)
                
                tenDaysInfo()
                
                description()
                
                fullDescription()
                
                
                
                
            }.padding(.bottom,80)
            .ignoresSafeArea(.all, edges: .all)

                footer()
                    
                
            }.ignoresSafeArea(.all, edges: .bottom)


            .sheet(isPresented: $userdata.goToList, content: {
                citiesList()
            })

 
        }.onAppear{
            for city in cities {
                userdata.getDataFor(lon: city.long, lad: city.lat)
            }
            


        }
        .frame(width: width, height: height)
        .background(LinearGradient(gradient:Gradient(colors:userdata.isDay() == true ? [Color("collect2-1"),Color("collect2-2")]:[Color("collect1-1"),Color("collect1-2")]) , startPoint: .top, endPoint: .bottom))


        
        }else {
            loadingView()

        }
        }.onReceive(timer) { _ in
            if threeSecond > 0 {
                threeSecond-=1
            }else{
                timer.upstream.connect().cancel()
            }
        }
}

}
private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .medium
    return formatter
}()


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
struct headMainInfo:View{
    @State var cityName = ""
    @EnvironmentObject var userdata:getData
    var body: some View{
        VStack(alignment:.center){
            Text(cityName)
                .font(.title)
            Text(userdata.Data[userdata.citiesIndex].current.weather[0].main)
                .font(.headline)
            
            Text("\(Int(userdata.Data[userdata.citiesIndex].current.temp))º")
                .fontWeight(.light)
                .frame(width: 110)
                .font(.custom("", size: 70))
                .offset(x:10)
            
            Text("H:\(Int( userdata.Data[userdata.citiesIndex].daily[0].temp.max))º L:\(Int(userdata.Data[userdata.citiesIndex].daily[0].temp.min))º")
            
          
        }
    }

}

struct hourDegree:View{
    @State var time = ""
    @State var icon = ""
    @State var degree:Int = 0
    var body: some View{
        VStack(spacing:10){
            Text(time)
            LottieView(name: icon,loopMode: .loop)
                .frame(width: 40, height: 40)
            Text("\(degree)º")
        }.padding(.horizontal,15)
    }
}
struct hourDegreeScrollView:View{
    @EnvironmentObject var userdata:getData
    var body: some View{
        if userdata.Data.count > 0 {

            ScrollView(.horizontal, showsIndicators: false){
                HStack{
                    if userdata.Data.count > 0 {
                    ForEach(0..<24){index in
                        
                        hourDegree(time:getDateFormat(intervalTime: Double(userdata.Data[userdata.citiesIndex].hourly[index].dt), dateFormat: "hh a",timeZoneIdentifier:userdata.locationTimeZone)  , icon:getIcon(icon: userdata.Data[userdata.citiesIndex].hourly[index].weather[0].icon) , degree: Int(userdata.Data[userdata.citiesIndex].hourly[index].temp))
                    }
                    }
                 
              }
            }
            .padding(.vertical)

           }
        }
    }

struct dayRow:View{
    @State var day:String = ""
    @State var statusIcon:String = ""
    @State var heighestDegree:Int = 0
    @State var lowestDegree:Int = 0
    var body: some View{
        
        HStack{
            HStack{
                Text(day)
                    .padding(.leading)
                Spacer()
            }
            .frame(width: 140)
            
            Spacer()
            VStack{
                LottieView(name: statusIcon, loopMode: .loop)
                    .frame(width: 40, height: 40)
            }
            Spacer()
            VStack{
                Text("\(heighestDegree)     \(lowestDegree)")
                    .padding(.trailing)
                
            }
            
            
        }
    }
}
struct tenDaysInfo:View{
    let days = ["Sunady","Monday","Tuesday","Wednesday","Thursday","Friday","Saturday"]
    let lottieFileName = ["foggy","mist","partly-cloudy","partly-shower","snow-sunny","snow","storm","stormshowersday","sunny","thunder"]
    
    @EnvironmentObject var userdata:getData
    var body: some View{
        VStack{
            if userdata.Data.count > 0 {
            ForEach(0..<userdata.Data[userdata.citiesIndex].daily.count){index in
                dayRow(day: getDateFormat(intervalTime: Double(userdata.Data[userdata.citiesIndex].daily[index].dt),dateFormat: "EEEE" ,timeZoneIdentifier:userdata.locationTimeZone), statusIcon: getIcon(icon: userdata.Data[userdata.citiesIndex].daily[index].weather[0].icon), heighestDegree: Int(userdata.Data[userdata.citiesIndex].daily[index].temp.max), lowestDegree: Int(userdata.Data[userdata.citiesIndex].daily[index].temp.min))
            }
        }
    }
        Path{path in
            path.move(to: CGPoint(x: 0, y: 0))
            path.addLine(to: CGPoint(x:UIScreen.main.bounds.width, y: 0))
        }.stroke(Color(.lightGray),lineWidth: 1)
    }
}
private func getDateFormat(intervalTime:Double,dateFormat:String,timeZoneIdentifier:String)->String{
    let date = Date(timeIntervalSince1970: intervalTime)
    
   
    let dateFormatter = DateFormatter()
    if timeZoneIdentifier != "current"{
        dateFormatter.timeZone = TimeZone(identifier: timeZoneIdentifier)
    }
    dateFormatter.dateFormat = dateFormat//"EEEE"
    
    return (dateFormatter.string(from: date))
    
}



func getIcon(icon:String)->String{
    switch icon {
    case "01d":
        return "sunny"
    case "02d":
        return "partly-cloudy"
    case "03d":
        return "foggy"
    case "04d":
        return "foggy"
    case "09d":
        return "partly-shower"
    case "10d":
        return "partly-shower"
    case "11d":
        return "stormshowersday"
    case "13d":
        return "snow"
    case "50d":
        return "foggy"
    case "01n":
        return "night"
    case "02n":
        return "cloudynight"
    case "03n":
        return "mist"
    case "04n":
        return "mist"
    case "09n":
        return "rainynight"
    case "10n":
        return "rainynight"
    case "11n":
        return "storm"
    case "13n":
        return "snownight"
    case "50n":
        return "mist"

    default:
        return "sunny"
    }
}

struct description:View{
    @EnvironmentObject var userdata:getData
    var body: some View{
        if userdata.Data.count > 0 {
        Text("Today:\(userdata.Data[userdata.citiesIndex].current.weather[0].weatherDescription) courrently.It's \(Int(userdata.Data[userdata.citiesIndex].current.temp))º; the high today was forest as \(Int(userdata.Data[userdata.citiesIndex].daily[0].temp.max))º")
            .frame(width: UIScreen.main.bounds.width-40,height: 60)
        }
        Path{path in
            path.move(to: CGPoint(x: 0, y: 0))
            path.addLine(to: CGPoint(x:UIScreen.main.bounds.width, y: 0))
        }.stroke(Color(.lightGray),lineWidth: 1)

    }
}

struct fullDescription:View{
    @EnvironmentObject var userdata:getData
    var body: some View{
        if userdata.Data.count > 0 {
        VStack(spacing:15){
            HStack{
                HStack{
                VStack(alignment:.leading){
                    Text("SUNRISE")
                        .font(.footnote)
                    Text(getDateFormat(intervalTime: Double(userdata.Data[userdata.citiesIndex].current.sunrise ?? 0), dateFormat: "hh:mm a",timeZoneIdentifier:userdata.locationTimeZone))
                        .font(.title3)
                        
                }
                    Spacer()

                }.padding(.leading)
                .frame(width: UIScreen.main.bounds.width/2)
                VStack(alignment:.leading){
                    Text("SUNSET")
                        .font(.footnote)
                    Text(getDateFormat(intervalTime: Double(userdata.Data[userdata.citiesIndex].current.sunset ?? 0), dateFormat: "hh:mm a",timeZoneIdentifier:userdata.locationTimeZone))
                        .font(.title3)
                }
                Spacer()

            }
            
            HStack{
                HStack{
                VStack(alignment:.leading){
                    Text("CHANCE OF RAIN")
                        .font(.footnote)
                    Text("\(Int(userdata.Data[userdata.citiesIndex].hourly[0].pop!  * 100))%")
                        .font(.title3)
                }
                    Spacer()
                }.padding(.leading)
                .frame(width: UIScreen.main.bounds.width/2)
                VStack(alignment:.leading){
                    Text("HUMIDITY")
                        .font(.footnote)
                    Text("\(Int(userdata.Data[userdata.citiesIndex].current.humidity))%")
                        .font(.title3)
                }
                Spacer()
            }
            
            HStack{
                HStack{
                VStack(alignment:.leading){
                    Text("WIND")
                        .font(.footnote)
                    Text("\(Int(userdata.Data[userdata.citiesIndex].current.windSpeed)) m/s")
                        .font(.title3)
                }
                    Spacer()
                }.padding(.leading)
                .frame(width: UIScreen.main.bounds.width/2)
                VStack(alignment:.leading){
                    Text("FEEL LIKE")
                        .font(.footnote)
                    Text("\(Int(userdata.Data[userdata.citiesIndex].current.feelsLike))º")
                        .font(.title3)
                }
                Spacer()
            }
                        
            HStack{
                HStack{
                VStack(alignment:.leading){
                    Text("VISIBILITY")
                    Text("\(userdata.Data[userdata.citiesIndex].current.visibility) m")
                }
                    Spacer()
                }.padding(.leading)
                .frame(width: UIScreen.main.bounds.width/2)
                VStack(alignment:.leading){
                    Text("UV INDEX")
                    Text("\(Int(userdata.Data[userdata.citiesIndex].current.uvi))")
                }
                Spacer()
            }
            
            HStack{
                HStack{
                    VStack(alignment:.leading){
                        Text("PRESSURE")
                        Text("\(userdata.Data[userdata.citiesIndex].current.pressure) hPa")
                    }
                    Spacer()
                }.padding(.leading)
                .frame(width: UIScreen.main.bounds.width/2)
                VStack(alignment:.leading){
                }
                Spacer()
            }

          }
        }
    }
}
struct footer:View{
    @EnvironmentObject var userdata:getData
    var body: some View{
        HStack{
            Spacer()
            Button(action: {userdata.goToList=true;userdata.backToMain=false}, label: {
                Image(systemName: "list.bullet")
                    .resizable()
                    .frame(width: 25, height: 25)
                    .padding(.trailing)
                    .foregroundColor(.white)
            })

        }
        .frame(width: UIScreen.main.bounds.width, height: 80)
        .background(userdata.isDay() == true ? Color("collect2-c"):Color("collect1-c"))
        .shadow(radius: 5)
    }
}
struct loadingView:View{
    let width = UIScreen.main.bounds.width
    let height = UIScreen.main.bounds.height
    @State var show = false
    var body: some View{
        ZStack{
        Rectangle()
            .frame(width: width, height: height)
            .foregroundColor(Color("collect2-1"))
            .ignoresSafeArea()
            
            VStack{
                Text("Weather.JO")
                    .bold()
                    .font(.title)
                    .foregroundColor(.white)
                    .opacity(show ? 1:0.1)
                
                Image("launchingScreenPhoto")
                    .resizable()
                    .frame(width:show ? 250:50, height: show ?250:50)
                    .opacity(show ? 1:0.1)
                    
                
            }
        
    }.onAppear{
        withAnimation(.easeIn(duration: 1.5)){
            show = true
        }
    }
  }
}
