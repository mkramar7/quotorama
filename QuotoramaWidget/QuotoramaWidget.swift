//
//  QuotoramaWidget.swift
//  QuotoramaWidget
//
//  Created by Marko Kramar on 15.02.2021..
//

import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    let quotesStore = QuotesStore()
    
    func placeholder(in context: Context) -> SimpleEntry {
        return SimpleEntry(date: Date(), quote: quotesStore.nextQuote)
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), quote: quotesStore.nextQuote)
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = SimpleEntry(date: entryDate, quote: quotesStore.nextQuote)
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let quote: Quote
}

struct QuotoramaWidgetEntryView: View {
    var entry: Provider.Entry
    
    var body: some View {
        VStack {
            VStack(alignment: .leading) {
                Text("„\(entry.quote.text)“")
                    .italic()
                    .font(Font.custom("Baskerville", size: 20))
                    .foregroundColor(.white)
                    .padding(.bottom, 10)
                    .minimumScaleFactor(0.5)
                    
                HStack {
                    Spacer()
                    
                    Text(entry.quote.author)
                        .italic()
                        .font(Font.custom("Baskerville", size: 15))
                        .foregroundColor(.white)
                        .padding(.trailing, -5)
                }
            }
            .animation(.spring())
            .padding(.horizontal, 25)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.black)
    }
}

@main
struct QuotoramaWidget: Widget {
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: "QuotoramaWidget", provider: Provider()) { entry in
            QuotoramaWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Quotorama")
        .description("Shows a new inspirational quote every hour of the day.")
        .supportedFamilies([.systemSmall, .systemMedium])
    }
}


