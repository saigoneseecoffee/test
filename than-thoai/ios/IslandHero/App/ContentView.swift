// Chỉ target IslandHero (thay file cùng tên Xcode tạo sẵn)
import SwiftUI

struct ContentView: View {
    @State private var s = GameStore.mutate { _ in }
    @Environment(\.scenePhase) private var phase
    private let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    var body: some View {
        VStack(spacing: 18) {
            Text("Island Hero").font(.largeTitle.bold())
            Text(s.isBoss ? "Stage \(s.stage)   BOSS" : "Stage \(s.stage)   \(s.kills)/10")
                .font(.headline.monospaced())

            HStack(spacing: 40) {
                Text("🛡️").font(.system(size: 56))
                Text(s.monster.icon).font(.system(size: s.isBoss ? 72 : 52))
            }

            ProgressView(timerInterval: s.fightStart...s.fightEnd, countsDown: true) {
                Text(s.monster.name)
            } currentValueLabel: {
                Text(timerInterval: s.fightStart...s.fightEnd, countsDown: true)
            }
            .tint(s.isBoss ? .red : .orange)

            Text("\(s.gold) vàng   Cấp \(s.level)   Công \(s.atk)   Rương \(s.chests)")
                .font(.subheadline.monospaced())
            Text(s.note).foregroundStyle(.secondary)

            HStack {
                Button("Chém mạnh") { act { $0.useSkill() } }
                Button("Mở rương (\(s.chests))") { act { $0.openChest() } }.disabled(s.chests == 0)
            }
            .buttonStyle(.borderedProminent)

            Button("Rèn kiếm: +3 công, \(s.forgeCost) vàng") { act { $0.upgrade() } }
                .buttonStyle(.bordered)
                .disabled(s.gold < s.forgeCost)

            Divider()

            Button("Bật trên Dynamic Island") { Task { await IslandActivity.start() } }
                .buttonStyle(.borderedProminent).tint(.black)
            Button("Tắt island", role: .destructive) { Task { await IslandActivity.stop() } }
        }
        .padding()
        .onReceive(timer) { _ in refresh() }
        .onChange(of: phase) { _, p in if p == .active { refresh() } }
    }

    private func act(_ change: (inout GameState) -> Void) {
        s = GameStore.mutate(change)
        let snapshot = s
        Task { await IslandActivity.update(snapshot) }
    }

    private func refresh() {
        let oldEnd = s.fightEnd
        s = GameStore.mutate { _ in }
        if s.fightEnd != oldEnd {
            let snapshot = s
            Task { await IslandActivity.update(snapshot) }
        }
    }
}
