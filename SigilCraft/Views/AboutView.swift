import SwiftUI

struct AboutView: View {
    var body: some View {
        NavigationStack {
            ZStack {
                ArcaneBackground()
                ScrollView {
                    VStack(spacing: 18) {
                        VStack(spacing: 6) {
                            Image(systemName: "book.closed")
                                .font(.system(size: 30))
                                .foregroundColor(Arcane.gold)
                            BiLabel(ja: "シギルとは", en: "About Sigils",
                                    jaSize: 20, enSize: 12, align: .center)
                            ArcaneDivider().frame(width: 200)
                        }
                        .padding(.top, 12)
                        .frame(maxWidth: .infinity)

                        section(
                            ja: "シギルは、願いや意図を一つの抽象的な図形に凝縮したもの。中世の魔術書では天使や惑星の「印章」として描かれ、20世紀初頭の芸術家オースティン・オスマン・スペアが、文から文字を削って図形を組む簡潔な手法を広めました。",
                            en: "A sigil is a desire or intent condensed into a single abstract figure. Medieval grimoires drew them as the \u{201C}seals\u{201D} of angels and planets, while the artist Austin Osman Spare (1886\u{2013}1956) popularised the simple technique of reducing a sentence into a glyph.")

                        section(
                            ja: "カオスマジックの実践では、シギルを作る過程そのものよりも、完成した図形に意識を集中し、その後で意味を「忘れる」ことが重視されます。象徴を無意識に沈めることで働くと考えられています。",
                            en: "In chaos magic practice, what matters is less the crafting than charging the finished glyph with focused attention, then forgetting its meaning — letting the symbol sink into the unconscious.")

                        section(
                            ja: "本アプリのアルファベット魔法円と七惑星の魔方陣（カメア）は、コルネリウス・アグリッパ『オカルト哲学』などの古典的資料に基づいています。",
                            en: "The alphabet wheel and the seven planetary kamea in this app draw on classical sources such as Cornelius Agrippa\u{2019}s Three Books of Occult Philosophy.")

                        VStack(alignment: .leading, spacing: 8) {
                            BiLabel(ja: "ご注意", en: "Please note", jaSize: 14, enSize: 11)
                            Text("本アプリは娯楽・創作・教養を目的としています。医療・法律・投資その他、専門的な判断の代わりにはなりません。")
                                .font(.system(size: 12))
                                .foregroundColor(Arcane.ash)
                            Text("For entertainment and creative use only. Not a substitute for professional advice.")
                                .font(.system(size: 11, design: .serif)).italic()
                                .foregroundColor(Arcane.ash.opacity(0.8))
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .arcaneCard()

                        Spacer(minLength: 20)
                    }
                    .padding()
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("解説 · About")
                        .font(.system(size: 15, weight: .light, design: .serif))
                        .foregroundColor(Arcane.gold)
                }
            }
        }
    }

    private func section(ja: String, en: String) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(ja)
                .font(.system(size: 14))
                .foregroundColor(Arcane.bone.opacity(0.92))
                .fixedSize(horizontal: false, vertical: true)
            Text(en)
                .font(.system(size: 12, design: .serif)).italic()
                .foregroundColor(Arcane.ash)
                .fixedSize(horizontal: false, vertical: true)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .arcaneCard()
    }
}

#Preview { AboutView() }
