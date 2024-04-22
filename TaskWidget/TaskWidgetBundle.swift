//
//  TaskWidgetBundle.swift
//  TaskWidget
//
//  Created by XREAL on 2024/4/22.
//

import WidgetKit
import SwiftUI

@main
struct TaskWidgetBundle: WidgetBundle {
    var body: some Widget {
        TaskWidget()
        TaskWidgetLiveActivity()
    }
}
