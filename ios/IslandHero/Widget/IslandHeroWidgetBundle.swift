// Chỉ target IslandHeroWidgetExtension (thay file cùng tên Xcode tạo sẵn)
import WidgetKit
import SwiftUI

@main
struct IslandHeroWidgetBundle: WidgetBundle {
    var body: some Widget {
        IslandHeroLiveActivity()
    }
}
