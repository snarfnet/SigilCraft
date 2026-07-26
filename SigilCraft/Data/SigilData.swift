import Foundation
import CoreGraphics

enum SigilData {

    // MARK: - Statement reduction (Austin Osman Spare method)

    /// Uppercased A–Z only.
    static func lettersOnly(_ text: String) -> String {
        String(text.uppercased().unicodeScalars.filter { $0 >= "A" && $0 <= "Z" }.map(Character.init))
    }

    /// Remove vowels, then remove repeated letters, keeping first occurrence.
    /// Returns the unique consonant string used to build the glyph.
    static func reduce(_ text: String, dropVowels: Bool) -> String {
        let vowels: Set<Character> = ["A", "E", "I", "O", "U"]
        var seen = Set<Character>()
        var result = ""
        for ch in lettersOnly(text) {
            if dropVowels && vowels.contains(ch) { continue }
            if seen.contains(ch) { continue }
            seen.insert(ch)
            result.append(ch)
        }
        return result
    }

    // MARK: - Wheel geometry (alphabet arranged around a circle)

    /// Angle (radians) for a letter on the 26-point wheel, starting at top, clockwise.
    static func angle(for letter: Character) -> CGFloat {
        guard let scalar = letter.unicodeScalars.first else { return 0 }
        let index = Int(scalar.value) - 65  // 'A' = 0
        let frac = CGFloat(index) / 26.0
        return -CGFloat.pi / 2 + frac * 2 * CGFloat.pi
    }

    /// Points on a circle of given radius/center for each letter in the reduced string.
    static func wheelPoints(for reduced: String, center: CGPoint, radius: CGFloat) -> [CGPoint] {
        reduced.map { ch in
            let a = angle(for: ch)
            return CGPoint(x: center.x + cos(a) * radius, y: center.y + sin(a) * radius)
        }
    }

    // MARK: - Planetary squares (kamea)

    static let planets: [SigilPlanet] = [
        SigilPlanet(symbol: "♄", nameJa: "土星", nameEn: "Saturn", latin: "Saturnus",
                    dayJa: "土曜日", dayEn: "Saturday", metal: "Lead / 鉛",
                    keywordsJa: "制約・時間・構造・忍耐", keywordsEn: "Limitation, time, structure, discipline",
                    kamea: [[4,9,2],[3,5,7],[8,1,6]]),
        SigilPlanet(symbol: "♃", nameJa: "木星", nameEn: "Jupiter", latin: "Iuppiter",
                    dayJa: "木曜日", dayEn: "Thursday", metal: "Tin / 錫",
                    keywordsJa: "拡大・幸運・繁栄・寛容", keywordsEn: "Expansion, fortune, prosperity",
                    kamea: [[4,14,15,1],[9,7,6,12],[5,11,10,8],[16,2,3,13]]),
        SigilPlanet(symbol: "♂", nameJa: "火星", nameEn: "Mars", latin: "Mars",
                    dayJa: "火曜日", dayEn: "Tuesday", metal: "Iron / 鉄",
                    keywordsJa: "意志・闘争・情熱・勇気", keywordsEn: "Will, conflict, passion, courage",
                    kamea: [[11,24,7,20,3],[4,12,25,8,16],[17,5,13,21,9],[10,18,1,14,22],[23,6,19,2,15]]),
        SigilPlanet(symbol: "☉", nameJa: "太陽", nameEn: "Sun", latin: "Sol",
                    dayJa: "日曜日", dayEn: "Sunday", metal: "Gold / 金",
                    keywordsJa: "生命・成功・名誉・自我", keywordsEn: "Life, success, honour, the self",
                    kamea: [[6,32,3,34,35,1],[7,11,27,28,8,30],[19,14,16,15,23,24],
                            [18,20,22,21,17,13],[25,29,10,9,26,12],[36,5,33,4,2,31]]),
        SigilPlanet(symbol: "♀", nameJa: "金星", nameEn: "Venus", latin: "Venus",
                    dayJa: "金曜日", dayEn: "Friday", metal: "Copper / 銅",
                    keywordsJa: "愛・美・調和・魅力", keywordsEn: "Love, beauty, harmony, attraction",
                    kamea: [[22,47,16,41,10,35,4],[5,23,48,17,42,11,29],[30,6,24,49,18,36,12],
                            [13,31,7,25,43,19,37],[38,14,32,1,26,44,20],[21,39,8,33,2,27,45],
                            [46,15,40,9,34,3,28]]),
        SigilPlanet(symbol: "☿", nameJa: "水星", nameEn: "Mercury", latin: "Mercurius",
                    dayJa: "水曜日", dayEn: "Wednesday", metal: "Quicksilver / 水銀",
                    keywordsJa: "知性・言葉・商い・伝達", keywordsEn: "Intellect, language, commerce",
                    kamea: [[8,58,59,5,4,62,63,1],[49,15,14,52,53,11,10,56],[41,23,22,44,45,19,18,48],
                            [32,34,35,29,28,38,39,25],[40,26,27,37,36,30,31,33],[17,47,46,20,21,43,42,24],
                            [9,55,54,12,13,51,50,16],[64,2,3,61,60,6,7,57]]),
        SigilPlanet(symbol: "☽", nameJa: "月", nameEn: "Moon", latin: "Luna",
                    dayJa: "月曜日", dayEn: "Monday", metal: "Silver / 銀",
                    keywordsJa: "感情・直感・夢・変化", keywordsEn: "Emotion, intuition, dreams, change",
                    kamea: [[37,78,29,70,21,62,13,54,5],[6,38,79,30,71,22,63,14,46],
                            [47,7,39,80,31,72,23,55,15],[16,48,8,40,81,32,64,24,56],
                            [57,17,49,9,41,73,33,65,25],[26,58,18,50,1,42,74,34,66],
                            [67,27,59,10,51,2,43,75,35],[36,68,19,60,11,52,3,44,76],
                            [77,28,69,20,61,12,53,4,45]])
    ]

    // MARK: - Method steps

    static let steps: [MethodStep] = [
        MethodStep(index: 1,
            titleJa: "意図を書く", titleEn: "State the Intent",
            bodyJa: "叶えたい願いを一つの短い肯定文にする。「私は〜する」の形で、現在形・肯定形で書くのが伝統的。例：「私は落ち着いて話す」。",
            bodyEn: "Write your desire as a single short affirmative sentence, in the present tense — e.g. \u{201C}IT IS MY WILL TO SPEAK CALMLY.\u{201D}"),
        MethodStep(index: 2,
            titleJa: "文字を削る", titleEn: "Reduce the Letters",
            bodyJa: "文から母音を取り除き、重複する子音を消していく。残った一組の文字が、シギルの骨組みになる。オースティン・オスマン・スペアが広めた古典的手法。",
            bodyEn: "Cross out the vowels, then all repeated letters. The remaining unique letters form the raw material of the glyph — the method popularised by Austin Osman Spare."),
        MethodStep(index: 3,
            titleJa: "図形を組む", titleEn: "Compose the Glyph",
            bodyJa: "残った文字を線・曲線・記号として一つの図形に結び合わせる。本アプリは文字を魔法円の上に配置し、順に結んで自動生成する。形は自由に整えてよい。",
            bodyEn: "Bind the remaining letters into one abstract figure. This app places them on a magic wheel and connects them in order; feel free to refine the shape by hand."),
        MethodStep(index: 4,
            titleJa: "チャージして忘れる", titleEn: "Charge, then Forget",
            bodyJa: "完成したシギルを凝視し、意識を集中(または放心)させてから、その意味を意図的に忘れる。カオスマジックでは「忘却」が働きの鍵とされる。",
            bodyEn: "Gaze at the finished sigil in a focused (or emptied) state, then deliberately forget its meaning. In chaos magic, this act of forgetting is considered essential.")
    ]
}
