//
//  StreakWidget.swift
//  StreakWidget
//
//  Created by Caio Marques on 15/02/24.
//

import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date())
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date())
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for dayOffset in 0 ..< 7 {
            let entryDate = Calendar.current.date(byAdding: .day, value: dayOffset, to: currentDate)!
            let entry = SimpleEntry(date: entryDate)
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    var date: Date
}

struct StreakWidgetEntryView : View {
    var entry: Provider.Entry
    var dataService : DataService = DataService()

    var body: some View {
        VStack {
            
            Group{
                Text("\(dataService.streak) dia\(dataService.streak > 1 ? "s" : "") de")
                    .font(.title3)
                    .bold()
                
                Text("gratidão")
                    .padding(.bottom, 10)
                    .font(.title3)
                    .bold()
                
                
                Image(systemName: "flame.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 40)
                
                if !dataService.wroteGratitudeToday {
                    Text("Seja grato!")
                }
                
            }
            .foregroundStyle(.white.opacity(0.9))
            .containerBackground(LinearGradient(colors: dataService.wroteGratitudeToday ? [Color.accentColor, .pink] : [.gray, Color(.systemGray3)], startPoint: .top, endPoint: .bottom), for: .widget)
        }
    }
}

struct StreakWidget: Widget {
    let kind: String = "StreakWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            StreakWidgetEntryView(entry: entry)
        }
        .supportedFamilies([.systemSmall])
        .configurationDisplayName("Streak de gratidão")
        .description("Veja a quantos dias você está escrevendo em seu diário da gratidão!")
    }
}

#Preview(as: .systemSmall) {
    StreakWidget()
} timeline: {
    SimpleEntry(date: .now)
    SimpleEntry(date: .now)
}
