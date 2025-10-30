//
//  Patchd_AlbumWidgetLiveActivity.swift
//  Patchd-AlbumWidget
//
//  Created by Ricardo Payares on 10/29/25.
//

import ActivityKit
import WidgetKit
import SwiftUI

struct Patchd_AlbumWidgetAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        // Dynamic stateful properties about your activity go here!
        var emoji: String
    }

    // Fixed non-changing properties about your activity go here!
    var name: String
}

struct Patchd_AlbumWidgetLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: Patchd_AlbumWidgetAttributes.self) { context in
            // Lock screen/banner UI goes here
            VStack {
                Text("Hello \(context.state.emoji)")
            }
            .activityBackgroundTint(Color.cyan)
            .activitySystemActionForegroundColor(Color.black)

        } dynamicIsland: { context in
            DynamicIsland {
                // Expanded UI goes here.  Compose the expanded UI through
                // various regions, like leading/trailing/center/bottom
                DynamicIslandExpandedRegion(.leading) {
                    Text("Leading")
                }
                DynamicIslandExpandedRegion(.trailing) {
                    Text("Trailing")
                }
                DynamicIslandExpandedRegion(.bottom) {
                    Text("Bottom \(context.state.emoji)")
                    // more content
                }
            } compactLeading: {
                Text("L")
            } compactTrailing: {
                Text("T \(context.state.emoji)")
            } minimal: {
                Text(context.state.emoji)
            }
            .widgetURL(URL(string: "http://www.apple.com"))
            .keylineTint(Color.red)
        }
    }
}

extension Patchd_AlbumWidgetAttributes {
    fileprivate static var preview: Patchd_AlbumWidgetAttributes {
        Patchd_AlbumWidgetAttributes(name: "World")
    }
}

extension Patchd_AlbumWidgetAttributes.ContentState {
    fileprivate static var smiley: Patchd_AlbumWidgetAttributes.ContentState {
        Patchd_AlbumWidgetAttributes.ContentState(emoji: "😀")
     }
     
     fileprivate static var starEyes: Patchd_AlbumWidgetAttributes.ContentState {
         Patchd_AlbumWidgetAttributes.ContentState(emoji: "🤩")
     }
}

#Preview("Notification", as: .content, using: Patchd_AlbumWidgetAttributes.preview) {
   Patchd_AlbumWidgetLiveActivity()
} contentStates: {
    Patchd_AlbumWidgetAttributes.ContentState.smiley
    Patchd_AlbumWidgetAttributes.ContentState.starEyes
}
