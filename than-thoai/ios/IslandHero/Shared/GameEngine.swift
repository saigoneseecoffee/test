// Thêm file này vào CẢ HAI target: IslandHero và IslandHeroWidgetExtension
import Foundation
import ActivityKit

// Dữ liệu gửi lên Dynamic Island
struct IslandHeroAttributes: ActivityAttributes {
    struct ContentState: Codable, Hashable {
        var stage: Int
        var kills: Int
        var isBoss: Bool
        var monsterIcon: String
        var monsterName: String
        var fightStart: Date
        var fightEnd: Date
        var gold: Int
        var chests: Int
        var level: Int
        var note: String
    }
    var heroName: String
}

struct Monster { let name: String; let icon: String }
let normalMonsters = [Monster(name: "Slime", icon: "🟢"),
                      Monster(name: "Dơi", icon: "🦇"),
                      Monster(name: "Bộ xương", icon: "💀")]
let bossMonster = Monster(name: "Hoả Long", icon: "🐉")

// Toàn bộ logic game. Mỗi trận có giờ bắt đầu và giờ kết thúc,
// island tự chạy thanh máu quái theo đồng hồ, không cần app chạy nền.
struct GameState: Codable {
    var stage = 1
    var kills = 0
    var level = 1
    var xp = 0
    var gold = 0
    var bonusAtk = 0
    var forge = 0
    var chests = 0
    var monsterIndex = 0
    var fightStart = Date()
    var fightEnd = Date().addingTimeInterval(3)
    var skillReadyAt = Date.distantPast
    var note = "Hero lên đường"

    var atk: Int { 6 + (level - 1) * 2 + bonusAtk + forge * 3 }
    var isBoss: Bool { kills >= 10 }
    var monster: Monster { isBoss ? bossMonster : normalMonsters[monsterIndex % normalMonsters.count] }
    var xpNeeded: Int { Int(20 * pow(1.5, Double(level - 1))) }
    var forgeCost: Int { Int(15 * pow(1.45, Double(forge))) }

    func monsterHP() -> Double { 22 * pow(1.33, Double(stage - 1)) * (isBoss ? 6 : 1) }
    func fightSeconds() -> Double { max(2, monsterHP() / (Double(atk) * 2)) }

    mutating func startFight(at date: Date) {
        monsterIndex = Int.random(in: 0..<normalMonsters.count)
        fightStart = date
        fightEnd = date.addingTimeInterval(fightSeconds())
    }

    // Tính hết các trận đã xong (kể cả lúc tắt app), tối đa 8 tiếng
    mutating func settle(now: Date = .now) {
        let maxAway: TimeInterval = 8 * 3600
        let away = now.timeIntervalSince(fightEnd)
        if away > maxAway {
            let shift = away - maxAway
            fightStart = fightStart.addingTimeInterval(shift)
            fightEnd = fightEnd.addingTimeInterval(shift)
        }
        var guardCount = 0
        while fightEnd <= now && guardCount < 20000 {
            let end = fightEnd
            win()
            startFight(at: end)
            guardCount += 1
        }
    }

    mutating func win() {
        if isBoss {
            gold += 20 * stage; xp += 15 * stage; chests = min(9, chests + 1)
            stage += 1; kills = 0
            note = "Hạ \(bossMonster.name)! Sang stage \(stage)"
        } else {
            gold += 2 * stage; xp += 3 * stage; kills += 1
            if Double.random(in: 0..<1) < 0.15 && chests < 9 { chests += 1; note = "Nhặt được rương" }
        }
        while xp >= xpNeeded { xp -= xpNeeded; level += 1; note = "Lên cấp \(level)!" }
    }

    mutating func useSkill(now: Date = .now) {
        guard now >= skillReadyAt, fightEnd > now else { return }
        let remain = fightEnd.timeIntervalSince(now)
        fightEnd = now.addingTimeInterval(remain * 0.4)   // chém mất 60% máu còn lại
        skillReadyAt = now.addingTimeInterval(8)
        note = "Chém mạnh!"
    }

    mutating func openChest() {
        guard chests > 0 else { return }
        chests -= 1
        let roll = Double.random(in: 0..<1)
        let (rarity, base): (String, Int) =
            roll < 0.02 ? ("Huyền thoại", 30) :
            roll < 0.12 ? ("Sử thi", 12) :
            roll < 0.40 ? ("Hiếm", 5) : ("Thường", 2)
        let gain = Int(Double(base) * (1 + 0.25 * Double(stage - 1)))
        bonusAtk += gain
        let item = ["Kiếm", "Khiên", "Mũ", "Nhẫn", "Giày"].randomElement() ?? "Kiếm"
        note = "\(item) \(rarity): +\(gain) công"
    }

    mutating func upgrade() {
        guard gold >= forgeCost else { return }
        gold -= forgeCost; forge += 1
        note = "Rèn xong, công \(atk)"
    }

    var contentState: IslandHeroAttributes.ContentState {
        .init(stage: stage, kills: kills, isBoss: isBoss,
              monsterIcon: monster.icon, monsterName: monster.name,
              fightStart: fightStart, fightEnd: fightEnd,
              gold: gold, chests: chests, level: level, note: note)
    }
}

// Lưu game vào máy
enum GameStore {
    private static let key = "islandHero.state"

    static func load() -> GameState {
        if let data = UserDefaults.standard.data(forKey: key),
           let s = try? JSONDecoder().decode(GameState.self, from: data) { return s }
        var s = GameState(); s.startFight(at: .now); return s
    }

    static func save(_ s: GameState) {
        if let data = try? JSONEncoder().encode(s) { UserDefaults.standard.set(data, forKey: key) }
    }

    @discardableResult
    static func mutate(_ change: (inout GameState) -> Void) -> GameState {
        var s = load(); s.settle(); change(&s); save(s); return s
    }
}
