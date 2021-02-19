//
//  ContentView.swift
//  Tamagotchi
//
//  Created by Ana Carolina on 19/02/21.
//

import SwiftUI

// Extensions for colors
extension Color {
    
    static let background = Color(UIColor(named: "background")!)
    static let colorui = Color(UIColor(named: "colorui")!)
    static let darkBlue = Color(UIColor(named: "bgdarkblue")!)
    static let cleanBlue = Color(UIColor(named: "bgcleanblue")!)
}

extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape( RoundedCorner(radius: radius, corners: corners) )
    }
}

struct RoundedCorner: Shape {

    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}


struct ContentView: View {
    @ObservedObject var tamagotchi: Tamagotchi
    
    @Environment (\.openURL) var openURL
    // save barometer
    @AppStorage("Barometer", store: UserDefaults(suiteName: "br.com.acarolsf.Tamagotchi"))
    var tamagotchiBarometer: Data = Data()
    
    init() {
        self.tamagotchi = Tamagotchi(name: "Zezin", gender: .male, age: 1, stomachMeter: 4, socialMeter: 2, imageName: "mametchi")
        
        guard let _ = try? JSONDecoder().decode(TamagotchiBarometer.self, from: tamagotchiBarometer) else {
            storeBarometer(with: TamagotchiBarometer(age: self.tamagotchi.age, stomachMeter: self.tamagotchi.stomachMeter, socialMeter: self.tamagotchi.socialMeter))

            return
        }
    }
    
    var body: some View {
        ZStack {
            (LinearGradient(gradient: Gradient(colors: [.darkBlue, .cleanBlue, .darkBlue]), startPoint: .topLeading, endPoint: .bottomTrailing))
                            .edgesIgnoringSafeArea(.all)
        VStack {
            Text("TAMAGOTCHI")
                .font(.largeTitle)
                .fontWeight(.thin)
                .foregroundColor(Color.white)
                .padding(.bottom, 30)
                .padding(.top, 50)
            // Tamagotchi Profile
            Image(tamagotchi.imageName).resizable().frame(width: 100, height: 100, alignment: .center)
                .padding()
                .background(Color.white)
                .clipShape(Circle())
                .shadow(radius: 10)
                .padding(.bottom, 30)
      
                    HStack {
                       
                        VStack {
                            HStack {
                                Text(tamagotchi.name).font(.title)
                            // change color between male and female
                                Text("\(tamagotchi.gender.rawValue)").foregroundColor(tamagotchi.gender == .male ? .blue : .pink).shadow(radius: 10).font(.title)
                            }
                            Text("\(tamagotchi.age) ano")
                        }
                    
                    }
                    .padding(.horizontal, 130)
                    .padding(.vertical, 20)
                    .background(Color.white)
                    .cornerRadius(20.0)
                    .shadow(radius: 20)
                    // part of social
            ZStack {
                VStack {
                   
                        HStack {
                            Text("Social")
                            Spacer()
                            HStack {
                                ForEach(0..<tamagotchi.socialMeter, id: \.self) {_ in
                                    Image(systemName: "heart.fill")
                                        .foregroundColor(.pink)
                                }
                                ForEach(0..<BAROMETER_MAX - tamagotchi.socialMeter, id: \.self) {_ in
                                    Image(systemName: "heart")
                                        .foregroundColor(.pink)
                                }
                            }
                        }
                        .padding(.horizontal, 60)
                        .padding(.vertical, 5)
                    
                    
                    
                    // healthy part
                  
                        HStack {
                            Text("Saúde")
                            Spacer()
                            HStack {
                                ForEach(0..<tamagotchi.stomachMeter, id: \.self) {_ in
                                    Image(systemName: "heart.fill")
                                        .foregroundColor(.pink)
                                }
                                ForEach(0..<BAROMETER_MAX - tamagotchi.stomachMeter, id: \.self) {_ in
                                    Image(systemName: "heart")
                                        .foregroundColor(.pink)
                                }
                            }
                        }
                        .padding(.horizontal, 60)
                        .padding(.vertical, 5)
                    
                }
                .padding(.horizontal)
                .frame(width: 360, height: 60, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
            }
            .padding(.vertical)
            .background(Color.white)
            .cornerRadius(20.0)
            .shadow(radius: 20)
                    
                    // Button
                    HStack {
                        Button(action: {
                            tamagotchi.fullSocialMeter()
                        }, label: {
                            HStack {
                                Image(systemName: "add")
                                Text("Social")
                                    .foregroundColor(.black)
                            }
                                                        
                        })
                        .padding(.horizontal, 26)
                        .padding(.vertical, 5)
                        .background(Color.white)
                        .cornerRadius(8.0)
                        .shadow(radius: 10)
                        
                        Spacer()
                        
                        Button(action: {
                            tamagotchi.fullStomachMeter()
                        }, label: {
                            HStack {
                                Image(systemName: "add")
                                Text("Saúde")
                                    .foregroundColor(.black)
                            }
                            
                        })
                        .padding(.horizontal, 25)
                        .padding(.vertical, 5)
                        .background(Color.white)
                        .cornerRadius(8.0)
                        .shadow(radius: 10)
                    }
                    .padding(.horizontal, 70)
                    .padding(.vertical, 10)
            
    
            VStack {
               Spacer()
                Button(action: {
                    openURL(URL(string: "https://www.instagram.com/acarolsf/")!)
                }) {
                    
                    Text("@ACAROLSF")
                        .font(.largeTitle)
                        .fontWeight(.thin)
                        .foregroundColor(Color.white)

                
                }
            }
        
                }
                
            
            
        }
        
    
    }
    
    func storeBarometer(with barometer: TamagotchiBarometer) {
        guard let encodeData = try? JSONEncoder().encode(barometer) else {
            return
        }
        self.tamagotchiBarometer = encodeData
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

