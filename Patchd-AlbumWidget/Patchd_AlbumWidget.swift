import WidgetKit
import SwiftUI

//MARK: - Simple Entry
struct SimpleEntry: TimelineEntry {
    let date: Date
    let configuration: ConfigurationAppIntent
    let photoCount: Int
}

//MARK: - Data Model
struct PhotoItem: Identifiable {
    let id: Int
    let offset: CGSize
    let rotation: Angle
    let scale: CGFloat
    let gradientColors: [Color]
}

//MARK: - Provider
struct Provider: AppIntentTimelineProvider {
    //Loading State
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), configuration: ConfigurationAppIntent(), photoCount: 1)
    }
    
    //Widget Library View
    func snapshot(for configuration: ConfigurationAppIntent, in context: Context) async -> SimpleEntry {
        SimpleEntry(date: Date(), configuration: configuration, photoCount: 3)
    }
    
    //Timeline Construction
    func timeline(for configuration: ConfigurationAppIntent, in context: Context) async -> Timeline<SimpleEntry> {
        var entries: [SimpleEntry] = []

        // Generate timeline entries that add a new photo every 30 minutes
        let currentDate = Date()
        let maxPhotos = 12 // Maximum photos in the collage
        
        for photoIndex in 1...maxPhotos {
            let entryDate = Calendar.current.date(byAdding: .second, value: (photoIndex - 1)  * 3, to: currentDate)!
            let entry = SimpleEntry(date: entryDate, configuration: configuration, photoCount: photoIndex)
            entries.append(entry)
        }

        return Timeline(entries: entries, policy: .atEnd)
    }
}

//MARK: - Entry View
struct Patchd_AlbumWidgetEntryView : View {
    var entry: Provider.Entry
    
    // Generate consistent random values for each photo based on its index
    private func generatePhotoItem(index: Int) -> PhotoItem {
        // Use index as seed for deterministic "randomness"
        let seedX = Double(index * 37)
        let seedY = Double(index * 73)
        let seedRotation = Double(index * 27)
        let seedScale = Double(index * 187)
        let seedColor = index * 43
        
        // Generate offset within widget bounds
        let offsetX = sin(seedX) * 90 + cos(seedX * 4) * 50
        let offsetY = cos(seedY) * 120 + sin(seedY * 7) * 40
        
        // Generate rotation
        let rotation = sin(seedRotation) * 20
        
        // Generate scale
        let scale = 0.85 + (sin(seedScale) + 3) * 0.125
        
        // Generate gradient colors
        let gradients: [[Color]] = [
            [.blue.opacity(0.7), .purple.opacity(0.5)],
            [.pink.opacity(0.7), .orange.opacity(0.5)],
            [.green.opacity(0.7), .teal.opacity(0.5)],
            [.purple.opacity(0.7), .blue.opacity(0.5)],
            [.orange.opacity(0.7), .red.opacity(0.5)],
            [.teal.opacity(0.7), .cyan.opacity(0.5)],
            [.indigo.opacity(0.7), .purple.opacity(0.5)],
            [.yellow.opacity(0.7), .orange.opacity(0.5)]
        ]
        
        let gradientIndex = abs(seedColor) % gradients.count
        
        return PhotoItem(
            id: index,
            offset: CGSize(width: offsetX, height: offsetY),
            rotation: Angle(degrees: rotation),
            scale: scale,
            gradientColors: gradients[gradientIndex]
        )
    }
    
    //For the demo, we are only supporting .systemLarge family
    //If your widget supports more, the EntryView would be responsible
    //for returning the correct view according to size selected.
    var body: some View {
        ZStack {
            
            // Collage of photos
            ForEach(0..<entry.photoCount, id: \.self) { index in
                let photo = generatePhotoItem(index: index)
                
                RoundedRectangle(cornerRadius: 8)
                    .fill(
                        LinearGradient(
                            colors: photo.gradientColors,
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 60, height: 60)
                    .shadow(color: .black.opacity(0.2), radius: 4, x: 2, y: 2)
                    .rotationEffect(photo.rotation)
                    .scaleEffect(photo.scale)
                    .offset(photo.offset)
            }
            
            // Logo at top-center
            VStack {
                HStack {
                    Spacer()
                    Image("Patch'd_logo")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 40)
                        .shadow(color: .black.opacity(0.2), radius: 3, x: 0, y: 2)
                    Spacer()
                }
                .padding(.top, 16)
                Spacer()
            }
            
            // Photo counter overlay
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    HStack(spacing: 4) {
                        Image(systemName: "photo.stack")
                            .font(.system(size: 12, weight: .semibold))
                        Text("\(entry.photoCount)")
                            .font(.system(size: 14, weight: .bold))
                    }
                    .foregroundColor(.white)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 6)
                    .background(
                        Capsule()
                            .fill(.black.opacity(0.6))
                            .shadow(color: .black.opacity(0.3), radius: 2, x: 0, y: 1)
                    )
                    .padding(12)
                }
            }
        }
    }
}

struct Patchd_AlbumWidget: Widget {
    let kind: String = "Patchd_AlbumWidget"

    var body: some WidgetConfiguration {
        AppIntentConfiguration(kind: kind, intent: ConfigurationAppIntent.self, provider: Provider()) { entry in
            Patchd_AlbumWidgetEntryView(entry: entry)
                .containerBackground(.fill.tertiary, for: .widget)
        }
        .supportedFamilies([.systemLarge])
    }
}

//MARK: - Configurations Example
extension ConfigurationAppIntent {
    fileprivate static var smiley: ConfigurationAppIntent {
        let intent = ConfigurationAppIntent()
        intent.favoriteEmoji = "😀"
        return intent
    }
    
    fileprivate static var starEyes: ConfigurationAppIntent {
        let intent = ConfigurationAppIntent()
        intent.favoriteEmoji = "🤩"
        return intent
    }
}

//MARK: - Preivew
#Preview(as: .systemLarge) {
    Patchd_AlbumWidget()
} timeline: {
    SimpleEntry(date: .now, configuration: .smiley, photoCount: 1)
    SimpleEntry(date: .now.addingTimeInterval(180), configuration: .smiley, photoCount: 3)
    SimpleEntry(date: .now.addingTimeInterval(360), configuration: .smiley, photoCount: 6)
    SimpleEntry(date: .now.addingTimeInterval(540), configuration: .starEyes, photoCount: 9)
    SimpleEntry(date: .now.addingTimeInterval(540), configuration: .starEyes, photoCount: 12)
}
