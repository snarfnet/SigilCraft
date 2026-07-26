import SwiftUI

struct PlanetsView: View {
    var body: some View {
        NavigationStack {
            ZStack {
                ArcaneBackground()
                ScrollView {
                    VStack(spacing: 18) {
                        VStack(spacing: 6) {
                            Image(systemName: "circle.grid.cross")
                                .font(.system(size: 30))
                                .foregroundColor(Arcane.gold)
                            BiLabel(ja: "七惑星と魔方陣", en: "Seven Planets & Their Kamea",
                                    jaSize: 20, enSize: 12, align: .center)
                            Text("惑星ごとの魔方陣（カメア）は、伝統的にシギルを引くための格子として使われます。")
                                .font(.system(size: 12))
                                .foregroundColor(Arcane.ash)
                                .multilineTextAlignment(.center)
                            ArcaneDivider().frame(width: 210)
                        }
                        .padding(.top, 12)
                        .frame(maxWidth: .infinity)

                        ForEach(SigilData.planets) { planet in
                            PlanetCard(planet: planet)
                        }

                        Spacer(minLength: 20)
                    }
                    .padding()
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("惑星 · Planets")
                        .font(.system(size: 15, weight: .light, design: .serif))
                        .foregroundColor(Arcane.gold)
                }
            }
        }
    }
}

struct PlanetCard: View {
    let planet: SigilPlanet

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 14) {
                Text(planet.symbol)
                    .font(.system(size: 40))
                    .foregroundColor(Arcane.goldBright)
                    .frame(width: 56)
                VStack(alignment: .leading, spacing: 2) {
                    Text(planet.nameJa)
                        .font(.system(size: 19, weight: .semibold))
                        .foregroundColor(Arcane.bone)
                    Text("\(planet.nameEn)  ·  \(planet.latin)")
                        .font(.system(size: 12, design: .serif)).italic()
                        .foregroundColor(Arcane.ash)
                    Text("\(planet.dayJa) / \(planet.dayEn)  ·  \(planet.metal)")
                        .font(.system(size: 11))
                        .foregroundColor(Arcane.gold.opacity(0.8))
                }
                Spacer()
            }

            HStack(alignment: .top, spacing: 16) {
                KameaGrid(kamea: planet.kamea)
                VStack(alignment: .leading, spacing: 6) {
                    Text(planet.keywordsJa)
                        .font(.system(size: 13))
                        .foregroundColor(Arcane.bone.opacity(0.9))
                    Text(planet.keywordsEn)
                        .font(.system(size: 11, design: .serif)).italic()
                        .foregroundColor(Arcane.ash)
                }
                Spacer(minLength: 0)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .arcaneCard()
    }
}

struct KameaGrid: View {
    let kamea: [[Int]]

    private var cellSize: CGFloat {
        switch kamea.count {
        case 3: return 22
        case 4: return 19
        case 5: return 16
        case 6: return 14
        default: return 11
        }
    }

    var body: some View {
        VStack(spacing: 1) {
            ForEach(0..<kamea.count, id: \.self) { r in
                HStack(spacing: 1) {
                    ForEach(0..<kamea[r].count, id: \.self) { c in
                        Text("\(kamea[r][c])")
                            .font(.system(size: cellSize * 0.42, weight: .medium, design: .monospaced))
                            .foregroundColor(Arcane.goldBright)
                            .frame(width: cellSize, height: cellSize)
                            .background(Arcane.ink)
                            .overlay(Rectangle().stroke(Arcane.gold.opacity(0.25), lineWidth: 0.5))
                    }
                }
            }
        }
        .padding(4)
        .overlay(Rectangle().stroke(Arcane.gold.opacity(0.4), lineWidth: 1))
    }
}

#Preview { PlanetsView() }
