import SwiftUI

enum Arcane {
    static let night = Color(red: 0.05, green: 0.05, blue: 0.07)
    static let ink = Color(red: 0.09, green: 0.09, blue: 0.12)
    static let charcoal = Color(red: 0.14, green: 0.14, blue: 0.18)
    static let gold = Color(red: 0.83, green: 0.68, blue: 0.35)
    static let goldBright = Color(red: 0.95, green: 0.82, blue: 0.45)
    static let crimson = Color(red: 0.65, green: 0.15, blue: 0.20)
    static let crimsonLight = Color(red: 0.82, green: 0.28, blue: 0.30)
    static let bone = Color(red: 0.88, green: 0.85, blue: 0.78)
    static let ash = Color(red: 0.55, green: 0.53, blue: 0.50)
    static let violet = Color(red: 0.42, green: 0.30, blue: 0.52)
}

struct ArcaneBackground: View {
    var body: some View {
        ZStack {
            RadialGradient(
                colors: [Arcane.ink, Arcane.night],
                center: .center,
                startRadius: 40,
                endRadius: 600
            )
            .ignoresSafeArea()

            Canvas { context, size in
                // faint concentric rings
                let cx = size.width / 2
                let cy = size.height * 0.32
                for i in 1...6 {
                    let r = CGFloat(i) * 42
                    context.stroke(
                        Path(ellipseIn: CGRect(x: cx - r, y: cy - r, width: r * 2, height: r * 2)),
                        with: .color(Arcane.gold.opacity(0.04)),
                        lineWidth: 0.6
                    )
                }
                // scattered stars
                for i in 0..<40 {
                    let seed = i * 2749
                    let x = CGFloat(seed % Int(size.width))
                    let y = CGFloat((seed * 7) % Int(size.height))
                    let r = CGFloat(0.5 + Double(seed % 3) * 0.5)
                    context.fill(
                        Path(ellipseIn: CGRect(x: x, y: y, width: r, height: r)),
                        with: .color(Arcane.bone.opacity(0.15))
                    )
                }
            }
            .ignoresSafeArea()
        }
    }
}

struct ArcaneCard: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 14)
                    .fill(Arcane.charcoal.opacity(0.85))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 14)
                    .stroke(Arcane.gold.opacity(0.28), lineWidth: 1)
            )
    }
}

struct ArcaneDivider: View {
    var body: some View {
        HStack(spacing: 8) {
            line
            Image(systemName: "hexagon")
                .font(.system(size: 9))
                .foregroundColor(Arcane.gold.opacity(0.6))
            line
        }
        .padding(.vertical, 6)
    }

    private var line: some View {
        Rectangle()
            .fill(LinearGradient(
                colors: [.clear, Arcane.gold.opacity(0.35), .clear],
                startPoint: .leading, endPoint: .trailing
            ))
            .frame(height: 1)
    }
}

extension View {
    func arcaneCard() -> some View {
        modifier(ArcaneCard())
    }
}

// Bilingual label helper: Japanese primary, English secondary
struct BiLabel: View {
    let ja: String
    let en: String
    var jaSize: CGFloat = 15
    var enSize: CGFloat = 12
    var align: HorizontalAlignment = .leading

    var body: some View {
        VStack(alignment: align, spacing: 2) {
            Text(ja)
                .font(.system(size: jaSize, weight: .medium))
                .foregroundColor(Arcane.bone)
            Text(en)
                .font(.system(size: enSize, weight: .regular, design: .serif))
                .italic()
                .foregroundColor(Arcane.ash)
        }
    }
}
