//
//  Patchd_AlbumWidgetBundle.swift
//  Patchd-AlbumWidget
//
//  Created by Ricardo Payares on 10/29/25.
//

import WidgetKit
import SwiftUI

@main
struct Patchd_AlbumWidgetBundle: WidgetBundle {
    var body: some Widget {
        Patchd_AlbumWidget()
        Patchd_AlbumWidgetControl()
        Patchd_AlbumWidgetLiveActivity()
    }
}
