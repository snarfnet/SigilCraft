import SwiftUI

struct MethodView: View {
    var body: some View {
        NavigationStack {
            ZStack {
                ArcaneBackground()
                ScrollView {
                    VStack(spacing: 18) {
                        VStack(spacing: 6) {
                            Image(systemName: "list.number")
                                .font(.system(size: 30))
                                .foregroundColor(Arcane.gold)
                            BiLabel(ja: "シギルの作り方", en: "The Method of Sigils",
                                    jaSize: 20, enSize: 12, align: .center)
                            ArcaneDivider().frame(width: 200)
                        }
                        .padding(.top, 12)
                        .frame(maxWidth: .infinity)

                        ForEach(SigilData.steps) { step in
                            VStack(alignment: .leading, spacing: 10) {
                                HStack(spacing: 12) {
                                    Text("\(step.index)")
                                        .font(.system(size: 20, weight: .bold, design: .serif))
                                        .foregroundColor(Arcane.night)
                                        .frame(width: 36, height: 36)
                                        .background(Circle().fill(Arcane.gold))
                                    BiLabel(ja: step.titleJa, en: step.titleEn, jaSize: 17, enSize: 12)
                                }
                                Text(step.bodyJa)
                                    .font(.system(size: 14))
                                    .foregroundColor(Arcane.bone.opacity(0.9))
                                    .fixedSize(horizontal: false, vertical: true)
                                Text(step.bodyEn)
                                    .font(.system(size: 12, design: .serif))
                                    .italic()
                                    .foregroundColor(Arcane.ash)
                                    .fixedSize(horizontal: false, vertical: true)
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .arcaneCard()
                        }

                        Spacer(minLength: 20)
                    }
                    .padding()
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("技法 · Method")
                        .font(.system(size: 15, weight: .light, design: .serif))
                        .foregroundColor(Arcane.gold)
                }
            }
        }
    }
}

#Preview { MethodView() }
