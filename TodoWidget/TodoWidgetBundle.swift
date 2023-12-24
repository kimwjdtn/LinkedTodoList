//
//  TodoWidgetBundle.swift
//  TodoWidget
//
//  Created by kimwjdtn on 12/16/23.
//

import WidgetKit
import SwiftUI

@main
struct TodoWidgetBundle: WidgetBundle {
    var body: some Widget {
        TodoWidget()
        TodoWidgetLiveActivity()
    }
}
