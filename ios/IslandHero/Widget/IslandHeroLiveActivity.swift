// Chỉ target IslandHeroWidgetExtension
import ActivityKit
import WidgetKit
import SwiftUI
import AppIntents

typealias HeroState = IslandHeroAttributes.ContentState

struct IslandHeroLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: IslandHeroAttributes.self) { context in
            // Lock Screen
            LockView(s: context.state, stale: context.isStale)
                .padding(14)
                .activityBackgroundTint(Color.black.opacity(0.85))
                .activitySystemActionForegroundColor(.yellow)
        } dynamicIsland: { context in
            let s = context.state
            let stale = context.isStale
            return DynamicIsland {
                DynamicIslandExpandedRegion(.leading) {
                    VStack(spacing: 2) {
                        Text("🛡️").font(.title)
                        Text("Lv \(s.level)").font(.caption2.monospaced()).foregroundStyle(.secondary)
                    }
                }
                DynamicIslandExpandedRegion(.trailing) {
                    VStack(spacing: 2) {
                        Text(s.monsterIcon).font(s.isBoss ? .largeTitle : .title)
                        Text(s.monsterName).font(.caption2).foregroundStyle(.secondary)
                    }
                }
                DynamicIslandExpandedRegion(.center) {
                    VStack(spacing: 4) {
                        Text(s.isBoss ? "Stage \(s.stage)  BOSS" : "Stage \(s.stage)  \(s.kills)/10")
                            .font(.caption.monospaced().bold())
                            .foregroundStyle(s.isBoss ? .red : .yellow)
                        Text(s.note).font(.caption2).foregroundStyle(.secondary).lineLimit(1)
                    }
                }
                DynamicIslandExpandedRegion(.bottom) {
                    VStack(spacing: 8) {
                        FightBar(s: s, stale: stale)
                        ActionRow(s: s, stale: stale)
                    }
                }
            } compactLeading: {
                HStack(spacing: 3) {
                    Text("🛡️")
                    Text("\(s.stage)").font(.caption2.monospaced().bold()).foregroundStyle(.yellow)
                }
            } compactTrailing: {
                if stale {
                    Text("🎁")
                } else {
                    ProgressView(timerInterval: s.fightStart...s.fightEnd, countsDown: true) {
                        EmptyView()
                    } currentValueLabel: {
                        Text(s.monsterIcon).font(.system(size: 9))
                    }
                    .progressViewStyle(.circular)
                    .tint(s.isBoss ? .red : .orange)
                }
            } minimal: {
                Text(stale ? "🎁" : s.monsterIcon)
            }
            .keylineTint(.yellow)
        }
    }
}

// Thanh máu quái: tự tụt theo đồng hồ, không cần cập nhật
struct FightBar: View {
    let s: HeroState
    let stale: Bool
    var body: some View {
        HStack(spacing: 8) {
            if stale {
                ProgressView(value: 0).tint(.green)
                Text("Thắng!").font(.caption.monospaced()).foregroundStyle(.green)
            } else {
                ProgressView(timerInterval: s.fightStart...s.fightEnd, countsDown: true) {
                    EmptyView()
                } currentValueLabel: {
                    EmptyView()
                }
                .tint(s.isBoss ? .red : .orange)
                Text(timerInterval: s.fightStart...s.fightEnd, countsDown: true)
                    .font(.caption.monospacedDigit())
                    .frame(width: 44, alignment: .trailing)
            }
        }
    }
}

struct ActionRow: View {
    let s: HeroState
    let stale: Bool
    var body: some View {
        HStack(spacing: 8) {
            if stale {
                Button(intent: ClaimIntent()) { pill("Nhận thưởng", .green) }
            } else {
                Button(intent: SkillIntent()) { pill("Chém mạnh", .white) }
            }
            Button(intent: ChestIntent()) { pill("Rương \(s.chests)", .yellow) }
                .disabled(s.chests == 0)
            Text("\(s.gold)💰").font(.caption.monospaced()).foregroundStyle(.yellow)
        }
        .buttonStyle(.plain)
    }

    private func pill(_ t: String, _ c: Color) -> some View {
        Text(t).font(.caption.bold()).foregroundStyle(c)
            .padding(.horizontal, 12).padding(.vertical, 7)
            .background(Capsule().fill(Color.white.opacity(0.12)))
    }
}

struct LockView: View {
    let s: HeroState
    let stale: Bool
    var body: some View {
        VStack(spacing: 10) {
            HStack {
                Text("🛡️").font(.title)
                VStack(alignment: .leading, spacing: 2) {
                    Text(s.isBoss ? "Stage \(s.stage)  BOSS" : "Stage \(s.stage)  \(s.kills)/10")
                        .font(.caption.monospaced().bold()).foregroundStyle(.yellow)
                    Text(s.note).font(.caption2).foregroundStyle(.secondary).lineLimit(1)
                }
                Spacer()
                Text(s.monsterIcon).font(.title)
            }
            FightBar(s: s, stale: stale)
            ActionRow(s: s, stale: stale)
        }
        .foregroundStyle(.white)
    }
}
