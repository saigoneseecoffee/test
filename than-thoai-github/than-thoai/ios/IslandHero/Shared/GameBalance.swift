//
//  GameBalance.swift
//  Island Hero - Idle RPG Game Balance System
//  Swift 5.9 | iOS 17 | Foundation Only
//
//  Bản gốc: Gemini. Đã sửa (đánh dấu [SỬA]):
//  1. Lỗi biên dịch "if let" với init không optional trong runSelfCheck
//  2. Máu/công quái tăng cùng nhịp với hero (trước đây quái tăng nhanh hơn ~80 lần về cuối game)
//  3. Kinh nghiệm thưởng bám theo đường cấp mục tiêu (trước đây xong Nhân Gian đã cấp ~186 thay vì 150)
//  4. Boss hồi có nhiều thời gian hơn boss chương (trước đây bị ngược)
//  5. Boss luôn rơi rương; mở độ khó yêu cầu đã qua màn 10 của chương cuối
//

import Foundation

// MARK: - 1. BalanceTuning (Hằng số cân bằng)
public struct BalanceTuning {

    // --- MỐC CẤP HERO ---
    public static let maxHeroLevel: Int = 500
    public static let nhanGianMaxLevel: Int = 150
    public static let amPhuMaxLevel: Int = 320
    public static let thienGioiMaxLevel: Int = 500

    // --- KINH NGHIỆM ---
    /// XP cần lên cấp: xpBase * L^xpExponent
    public static let xpBase: Double = 100.0
    public static let xpExponent: Double = 2.2
    /// [SỬA] Tỉ lệ kinh nghiệm nhận được nếu chỉ đi thẳng mỗi màn một lần.
    /// 0.85 = đi thẳng đạt ~85% mốc cấp, phần còn lại đến từ farm, offline và buff.
    public static let firstPassXpShare: Double = 0.85
    /// [SỬA] Boss chương cho XP gấp mấy lần màn thường (tổng XP mỗi chương giữ nguyên)
    public static let bossXpWeight: Double = 2.0

    // --- CHỈ SỐ HERO CẤP 1 ---
    public static let heroBaseHP: Double = 160.0
    public static let heroBaseAttack: Double = 35.0
    public static let heroBaseArmor: Double = 8.0
    public static let heroStatExponent: Double = 2.3

    // --- QUÁI ---
    public static let monsterBaseHP: Double = 120.0
    public static let monsterBaseAttack: Double = 24.0
    /// [SỬA] Bằng số mũ của hero, để số đòn hạ một quái chỉ tăng nhẹ theo hồi và độ khó
    /// (cấp 1: ~3.4 đòn, cấp 500 Thiên Giới: ~9 đòn cho 1 hero chưa có đồ)
    public static let monsterStatExponent: Double = 2.3
    public static let monsterAttackExponent: Double = 2.3

    /// Mỗi hồi tăng thêm 5%
    public static let arcStatBonusStep: Double = 0.05

    public static let difficultyMultipliers: [Difficulty: Double] = [
        .nhanGian: 1.0,
        .amPhu: 1.35,
        .thienGioi: 1.85
    ]

    public static let chapterBossHPMultiplier: Double = 2.8
    public static let chapterBossAttackMultiplier: Double = 1.35
    public static let arcBossHPMultiplier: Double = 6.5
    public static let arcBossAttackMultiplier: Double = 1.75

    /// [SỬA] Boss hồi máu gấp đôi boss chương nên cần nhiều thời gian hơn
    public static let chapterBossTime: TimeInterval = 60
    public static let arcBossTime: TimeInterval = 90

    // --- VÀNG ---
    public static let stageGoldBase: Double = 45.0
    public static let rewardExponent: Double = 2.2
}

// MARK: - 2. Difficulty
public enum Difficulty: Int, CaseIterable, Comparable, Codable, CustomStringConvertible {
    case nhanGian = 1
    case amPhu = 2
    case thienGioi = 3

    public var description: String {
        switch self {
        case .nhanGian: return "Nhân Gian"
        case .amPhu: return "Âm Phủ"
        case .thienGioi: return "Thiên Giới"
        }
    }

    public var chapterOffset: Int {
        switch self {
        case .nhanGian: return 0
        case .amPhu: return 100
        case .thienGioi: return 200
        }
    }

    public var minLevelToUnlock: Int {
        switch self {
        case .nhanGian: return 1
        case .amPhu: return BalanceTuning.nhanGianMaxLevel
        case .thienGioi: return BalanceTuning.amPhuMaxLevel
        }
    }

    /// Cấp cuối dự kiến của độ khó này
    public var endLevel: Int {
        switch self {
        case .nhanGian: return BalanceTuning.nhanGianMaxLevel
        case .amPhu: return BalanceTuning.amPhuMaxLevel
        case .thienGioi: return BalanceTuning.thienGioiMaxLevel
        }
    }

    public var requiredCompletedGlobalChapter: Int {
        switch self {
        case .nhanGian: return 0
        case .amPhu: return 100
        case .thienGioi: return 200
        }
    }

    public static func < (lhs: Difficulty, rhs: Difficulty) -> Bool {
        lhs.rawValue < rhs.rawValue
    }
}

// MARK: - 3. StageID
public struct StageID: Hashable, Equatable, CustomStringConvertible, Codable {
    public let difficulty: Difficulty
    public let chapter: Int // 1–100 trong độ khó
    public let stage: Int   // 1–10 trong chương

    public init(difficulty: Difficulty, chapter: Int, stage: Int) {
        self.difficulty = difficulty
        self.chapter = max(1, min(100, chapter))
        self.stage = max(1, min(10, stage))
    }

    public init?(globalChapter: Int, stage: Int) {
        guard (1...300).contains(globalChapter) else { return nil }
        let s = max(1, min(10, stage))
        if globalChapter <= 100 {
            self.init(difficulty: .nhanGian, chapter: globalChapter, stage: s)
        } else if globalChapter <= 200 {
            self.init(difficulty: .amPhu, chapter: globalChapter - 100, stage: s)
        } else {
            self.init(difficulty: .thienGioi, chapter: globalChapter - 200, stage: s)
        }
    }

    public var globalChapter: Int { difficulty.chapterOffset + chapter }
    public var globalStageIndex: Int { (globalChapter - 1) * 10 + stage }
    /// Nhãn "chương-màn", ví dụ "1-3", "101-1", "300-10"
    public var label: String { "\(globalChapter)-\(stage)" }
    public var description: String { "[\(difficulty.description)] Màn \(label)" }
    public var arc: Int { (chapter - 1) / 10 + 1 }
    public var isChapterBoss: Bool { stage == 10 }
    public var isArcBoss: Bool { isChapterBoss && chapter % 10 == 0 }

    public func next() -> StageID? {
        if stage < 10 { return StageID(difficulty: difficulty, chapter: chapter, stage: stage + 1) }
        if chapter < 100 { return StageID(difficulty: difficulty, chapter: chapter + 1, stage: 1) }
        switch difficulty {
        case .nhanGian: return StageID(difficulty: .amPhu, chapter: 1, stage: 1)
        case .amPhu: return StageID(difficulty: .thienGioi, chapter: 1, stage: 1)
        case .thienGioi: return nil
        }
    }
}

// MARK: - 4. StageConfig
public struct StageConfig {
    public let stageID: StageID
    public let recommendedLevel: Int
    public let monsterHP: Int64
    public let monsterAttack: Int64
    public let monsterCount: Int
    public let bossTimeLimit: TimeInterval?
    public let goldReward: Int64
    public let xpReward: Int64
    public let chestChance: Double
    public let fragmentDrop: Int
}

// MARK: - 5. GameBalance
public enum GameBalance {

    // MARK: Hiển thị số gọn
    public static func formatNumber(_ value: Int64) -> String {
        let absVal = Double(abs(value))
        let sign = value < 0 ? "-" : ""
        if absVal < 1_000 { return "\(value)" }
        let suffixes: [(Double, String)] = [
            (1e15, "P"), (1e12, "T"), (1e9, "B"), (1e6, "M"), (1e3, "K")
        ]
        for (threshold, suffix) in suffixes where absVal >= threshold {
            let str = String(format: "%.1f", absVal / threshold)
            let trimmed = str.hasSuffix(".0") ? String(str.dropLast(2)) : str
            return "\(sign)\(trimmed)\(suffix)"
        }
        return "\(value)"
    }

    private static func clampInt64(_ v: Double, min lo: Double = 1) -> Int64 {
        Int64(Swift.min(Double(Int64.max), Swift.max(lo, v.rounded())))
    }

    // MARK: Cấp khuyến nghị: tuyến tính trong từng độ khó
    public static func recommendedLevel(for id: StageID) -> Int {
        let start = id.difficulty.minLevelToUnlock
        let end = id.difficulty.endLevel
        let local = (id.chapter - 1) * 10 + id.stage          // 1…1000 trong độ khó
        let progress = Double(local - 1) / 999.0
        return start + Int((progress * Double(end - start)).rounded())
    }

    public static func xpToNextLevel(level: Int) -> Int64 {
        let l = Double(max(1, min(BalanceTuning.maxHeroLevel, level)))
        return clampInt64(BalanceTuning.xpBase * pow(l, BalanceTuning.xpExponent))
    }

    // MARK: Chỉ số hero
    public static func heroBaseStats(level: Int) -> (hp: Int64, attack: Int64, armor: Int64) {
        let l = Double(max(1, min(BalanceTuning.maxHeroLevel, level)))
        let scale = pow(l, BalanceTuning.heroStatExponent)
        return (
            hp: clampInt64(BalanceTuning.heroBaseHP * scale),
            attack: clampInt64(BalanceTuning.heroBaseAttack * scale),
            armor: clampInt64(BalanceTuning.heroBaseArmor * pow(l, 1.8))
        )
    }

    // MARK: Cấu hình màn (tính bằng công thức)
    public static func config(for id: StageID) -> StageConfig {
        let recLvl = recommendedLevel(for: id)
        let l = Double(recLvl)
        let arcBonus = 1.0 + Double(id.arc - 1) * BalanceTuning.arcStatBonusStep
        let diffBonus = BalanceTuning.difficultyMultipliers[id.difficulty] ?? 1.0

        var hp = BalanceTuning.monsterBaseHP * pow(l, BalanceTuning.monsterStatExponent) * arcBonus * diffBonus
        var atk = BalanceTuning.monsterBaseAttack * pow(l, BalanceTuning.monsterAttackExponent) * arcBonus * diffBonus

        let count: Int
        let time: TimeInterval?
        let chest: Double
        let fragments: Int

        if id.isArcBoss {
            count = 1; time = BalanceTuning.arcBossTime; chest = 1.0; fragments = 5 + id.arc
            hp *= BalanceTuning.arcBossHPMultiplier
            atk *= BalanceTuning.arcBossAttackMultiplier
        } else if id.isChapterBoss {
            count = 1; time = BalanceTuning.chapterBossTime; chest = 1.0; fragments = 1 + id.arc / 3  // [SỬA] boss luôn rơi rương
            hp *= BalanceTuning.chapterBossHPMultiplier
            atk *= BalanceTuning.chapterBossAttackMultiplier
        } else {
            count = 5 + ((id.chapter * 3 + id.stage) % 4)   // 5–8 quái
            time = nil; chest = 0.05; fragments = 0
        }

        // [SỬA] XP bám theo đường cấp: mỗi độ khó cần (endLevel - start) cấp qua 1.000 màn
        let d = id.difficulty
        let levelsPerStage = Double(d.endLevel - d.minLevelToUnlock) / 1000.0
        let normalWeight = 10.0 / (9.0 + BalanceTuning.bossXpWeight)   // giữ tổng mỗi chương
        let weight = id.isChapterBoss ? BalanceTuning.bossXpWeight * normalWeight : normalWeight
        let xp = Double(xpToNextLevel(level: recLvl)) * levelsPerStage * BalanceTuning.firstPassXpShare * weight

        let gold = BalanceTuning.stageGoldBase * pow(l, BalanceTuning.rewardExponent) * arcBonus * diffBonus
            * (id.isArcBoss ? 5 : id.isChapterBoss ? 2 : 1)

        return StageConfig(
            stageID: id,
            recommendedLevel: recLvl,
            monsterHP: clampInt64(hp, min: 10),
            monsterAttack: clampInt64(atk, min: 2),
            monsterCount: count,
            bossTimeLimit: time,
            goldReward: clampInt64(gold, min: 5),
            xpReward: clampInt64(xp, min: 5),
            chestChance: chest,
            fragmentDrop: fragments
        )
    }

    // MARK: Mở độ khó
    /// [SỬA] Phải qua màn 10 (boss) của chương cuối độ khó trước, không chỉ vào tới chương đó
    public static func isDifficultyUnlocked(_ difficulty: Difficulty, currentLevel: Int, highestClearedStage: StageID?) -> Bool {
        guard difficulty != .nhanGian else { return true }
        guard let c = highestClearedStage else { return false }
        let clearedAll = c.globalChapter > difficulty.requiredCompletedGlobalChapter
            || (c.globalChapter == difficulty.requiredCompletedGlobalChapter && c.stage == 10)
        return clearedAll && currentLevel >= difficulty.minLevelToUnlock
    }

    // MARK: - Self-check (debug)
    public static func runSelfCheck() {
        let samples: [StageID] = [(1, 1), (1, 10), (10, 10), (50, 10), (100, 10), (101, 1), (200, 10), (201, 1), (300, 10)]
            .compactMap { StageID(globalChapter: $0.0, stage: $0.1) }

        print("Màn     | Độ khó     | Cấp | HP quái    | Công quái  | SốQ | Giờ  | Vàng       | XP         | Rương | Mảnh | Đòn/quái")
        print(String(repeating: "-", count: 118))
        for id in samples {
            let c = config(for: id)
            let heroAtk = heroBaseStats(level: c.recommendedLevel).attack
            let hits = Double(c.monsterHP) / Double(max(1, heroAtk))
            let t = c.bossTimeLimit.map { "\(Int($0))s" } ?? "-"
            print([
                pad(id.label, 7), pad(id.difficulty.description, 10), pad("\(c.recommendedLevel)", 3),
                pad(formatNumber(c.monsterHP), 10), pad(formatNumber(c.monsterAttack), 10), pad("\(c.monsterCount)", 3),
                pad(t, 4), pad(formatNumber(c.goldReward), 10), pad(formatNumber(c.xpReward), 10),
                pad("\(Int(c.chestChance * 100))%", 5), pad("\(c.fragmentDrop)", 4), String(format: "%.1f", hits)
            ].joined(separator: " | "))
        }

        print("\nƯớc tính (mỗi màn ~60 giây, 1 hero, không tính farm thêm):")
        for d in Difficulty.allCases {
            var level = d.minLevelToUnlock
            var xp: Int64 = 0
            for ch in 1...100 {
                for st in 1...10 {
                    xp += config(for: StageID(difficulty: d, chapter: ch, stage: st)).xpReward   // [SỬA] bỏ "if let"
                    while level < BalanceTuning.maxHeroLevel && xp >= xpToNextLevel(level: level) {
                        xp -= xpToNextLevel(level: level); level += 1
                    }
                }
            }
            print("- \(d.description): đi thẳng ~\(1000 * 60 / 3600) giờ, cấp đạt được \(level) / mục tiêu \(d.endLevel)")
        }
    }

    private static func pad(_ s: String, _ w: Int) -> String {
        s.count >= w ? s : s + String(repeating: " ", count: w - s.count)
    }
}
