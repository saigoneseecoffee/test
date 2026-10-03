// Thêm file này vào CẢ HAI target
import AppIntents
import ActivityKit

enum IslandActivity {
    static func content(_ s: GameState) -> ActivityContent<IslandHeroAttributes.ContentState> {
        // staleDate = lúc trận xong -> island đổi sang nút "Nhận thưởng"
        ActivityContent(state: s.contentState, staleDate: s.fightEnd)
    }

    static func start() async {
        let s = GameStore.mutate { _ in }
        if let a = Activity<IslandHeroAttributes>.activities.first {
            await a.update(content(s)); return
        }
        do {
            _ = try Activity.request(attributes: IslandHeroAttributes(heroName: "Hiệp sĩ"),
                                     content: content(s), pushType: nil)
        } catch {
            print("Không bật được Live Activity: \(error)")
        }
    }

    static func update(_ s: GameState) async {
        for a in Activity<IslandHeroAttributes>.activities { await a.update(content(s)) }
    }

    static func stop() async {
        for a in Activity<IslandHeroAttributes>.activities { await a.end(nil, dismissalPolicy: .immediate) }
    }
}

// Các nút bấm trên island (chạy ngầm trong app, không cần mở app)
struct ClaimIntent: LiveActivityIntent {
    static let title: LocalizedStringResource = "Nhận thưởng"
    func perform() async throws -> some IntentResult {
        let s = GameStore.mutate { _ in }
        await IslandActivity.update(s)
        return .result()
    }
}

struct SkillIntent: LiveActivityIntent {
    static let title: LocalizedStringResource = "Chém mạnh"
    func perform() async throws -> some IntentResult {
        let s = GameStore.mutate { $0.useSkill() }
        await IslandActivity.update(s)
        return .result()
    }
}

struct ChestIntent: LiveActivityIntent {
    static let title: LocalizedStringResource = "Mở rương"
    func perform() async throws -> some IntentResult {
        let s = GameStore.mutate { $0.openChest() }
        await IslandActivity.update(s)
        return .result()
    }
}
