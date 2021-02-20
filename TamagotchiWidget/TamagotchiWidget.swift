//
//  TamagotchiWidget.swift
//  TamagotchiWidget
//
//  Created by Ana Carolina on 20/02/21.
//

import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    
    private let meterMax = 100
    
    @AppStorage("Barometer", store: UserDefaults(suiteName: "br.com.acarolsf.Tamagotchi"))
    var tamagotchiBarometer: Data = Data()
    
    
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), stomachMeter: self.meterMax, socialMeter: self.meterMax, happyMeter: self.meterMax, barometer: TamagotchiBarometer(age: 3, stomachMeter: 5, socialMeter: 5, happyMeter: 2))
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> Void) {
        
        var entry: SimpleEntry
        
        if let decodeData = try? JSONDecoder().decode(TamagotchiBarometer.self, from: tamagotchiBarometer) {
            entry = SimpleEntry(date: Date(), stomachMeter: self.meterMax, socialMeter: self.meterMax, happyMeter: self.meterMax, barometer: decodeData)
        } else {
            entry = SimpleEntry(date: Date(), stomachMeter: self.meterMax, socialMeter: self.meterMax, happyMeter: 2, barometer: TamagotchiBarometer(age: 3, stomachMeter: 5, socialMeter: 5, happyMeter: 2))
        }
        
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<SimpleEntry>) -> Void) {
        var entries: [SimpleEntry] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            var entry: SimpleEntry
            var barometer: TamagotchiBarometer = TamagotchiBarometer(age: 3, stomachMeter: 5, socialMeter: 5, happyMeter: 2)
            
            if let decodeData = try? JSONDecoder().decode(TamagotchiBarometer.self, from: tamagotchiBarometer) {
                            
                do {
                    barometer = try TamagotchiBarometer(from: decodeData as! Decoder)
                }
                catch let error as NSError {
                    print("Failure to Write File\n\(error)")
                }
            }
            else {
                return
            }
            
            let social = barometer.reduceSocialMeter()
            let stomach = barometer.reduceStomachMeter()
            let happy = barometer.reduceHappyMeter()
            
            entry = SimpleEntry(date: entryDate, stomachMeter: Int(self.meterMax * (social / BAROMETER_MAX)), socialMeter: Int(self.meterMax * (stomach / BAROMETER_MAX)), happyMeter: Int(self.meterMax * (happy / BAROMETER_MAX)), barometer: barometer)

            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let stomachMeter: Int
    let socialMeter: Int
    let happyMeter: Int
    let barometer: TamagotchiBarometer
}

struct TamagotchiWidgetEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        Color(red: 26, green: 26, blue: 26).edgesIgnoringSafeArea(.all).overlay(Group {
            HStack {
                Image("mametchi")
                    .resizable()
                    .frame(width: 40, height: 40, alignment: .center)
                VStack {
                    HStack {
                        Image(systemName: "circle.fill")
                            .foregroundColor(.yellow)
                        Text("\(entry.happyMeter)%")
                            .foregroundColor(.yellow)
                            .font(.system(.body, design: .rounded))
                    }
                    HStack {
                        Image(systemName: "heart.fill")
                            .foregroundColor(.pink)
                        Text("\(entry.socialMeter)%")
                            .foregroundColor(.pink)
                            .font(.system(.body, design: .rounded))
                    }
                    HStack {
                        Image(systemName: "triangle")
                            .foregroundColor(.orange)
                        Text("\(entry.stomachMeter)%")
                            .foregroundColor(.orange)
                            .font(.system(.body, design: .rounded))
                    }
                }
            }
        })
    }
}

@main
struct TamagotchiWidget: Widget {
    let kind: String = "TamagotchiWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            TamagotchiWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Tamagotchi Widget")
        .description("This is a Tamagotchi wiget.")
    }
}

struct TamagotchiWidget_Previews: PreviewProvider {
    static var previews: some View {
        TamagotchiWidgetEntryView(entry: SimpleEntry(date: Date(), stomachMeter: 95, socialMeter: 80, happyMeter: 90, barometer: TamagotchiBarometer(age: 3, stomachMeter: 5, socialMeter: 5, happyMeter: 2)))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
