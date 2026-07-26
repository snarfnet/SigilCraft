import SwiftUI

struct CreateView: View {
    @State private var intention = ""
    @State private var dropVowels = true
    @State private var showRings = true
    @State private var showLetters = false

    private var reduced: String {
        SigilData.reduce(intention, dropVowels: dropVowels)
    }

    var body: some View {
        NavigationStack {
            ZStack {
                ArcaneBackground()

                ScrollView {
                    VStack(spacing: 22) {
                        header

                        // Input
                        VStack(alignment: .leading, spacing: 8) {
                            BiLabel(ja: "意図を入力", en: "Enter your intent", jaSize: 12, enSize: 11)
                            TextField("", text: $intention, prompt: Text("I will…").foregroundColor(Arcane.ash))
                                .font(.system(size: 20, weight: .light, design: .serif))
                                .foregroundColor(Arcane.bone)
                                .padding(14)
                                .background(RoundedRectangle(cornerRadius: 12).fill(Arcane.ink))
                                .overlay(RoundedRectangle(cornerRadius: 12).stroke(Arcane.gold.opacity(0.35), lineWidth: 1))
                                .autocorrectionDisabled()
                        }

                        // Sigil canvas
                        SigilGlyphView(reduced: reduced, showRings: showRings, showLetters: showLetters)
                            .frame(height: 300)
                            .arcaneCard()

                        if !reduced.isEmpty {
                            reducedRow
                        }

                        // Options
                        VStack(spacing: 12) {
                            Toggle(isOn: $dropVowels) {
                                BiLabel(ja: "母音を除く", en: "Drop vowels", jaSize: 14, enSize: 11)
                            }
                            Toggle(isOn: $showRings) {
                                BiLabel(ja: "魔法円を表示", en: "Show wheel", jaSize: 14, enSize: 11)
                            }
                            Toggle(isOn: $showLetters) {
                                BiLabel(ja: "文字を表示", en: "Show letters", jaSize: 14, enSize: 11)
                            }
                        }
                        .tint(Arcane.crimsonLight)
                        .arcaneCard()

                        // Export
                        if !reduced.isEmpty {
                            exportButton
                        }

                        // Examples
                        exampleBlock

                        Spacer(minLength: 30)
                    }
                    .padding()
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Sigil Craft")
                        .font(.system(size: 17, weight: .light, design: .serif))
                        .foregroundColor(Arcane.gold)
                }
            }
        }
    }

    private var header: some View {
        VStack(spacing: 6) {
            Image(systemName: "wand.and.stars")
                .font(.system(size: 34))
                .foregroundColor(Arcane.gold)
            BiLabel(ja: "シギル工房", en: "Craft your own sigil", jaSize: 22, enSize: 13, align: .center)
                .multilineTextAlignment(.center)
            ArcaneDivider().frame(width: 200)
        }
        .padding(.top, 16)
        .frame(maxWidth: .infinity)
    }

    private var reducedRow: some View {
        VStack(spacing: 8) {
            BiLabel(ja: "残った文字", en: "Reduced letters", jaSize: 11, enSize: 10, align: .center)
            HStack(spacing: 6) {
                ForEach(Array(reduced.enumerated()), id: \.offset) { _, ch in
                    Text(String(ch))
                        .font(.system(size: 16, weight: .semibold, design: .serif))
                        .foregroundColor(Arcane.goldBright)
                        .frame(width: 30, height: 30)
                        .background(Circle().stroke(Arcane.gold.opacity(0.4), lineWidth: 1))
                }
            }
        }
        .frame(maxWidth: .infinity)
    }

    private var exportButton: some View {
        Button {
            exportSigil()
        } label: {
            HStack {
                Image(systemName: "square.and.arrow.up")
                Text("画像を保存 / Save Image")
            }
            .font(.system(size: 15, weight: .medium))
            .foregroundColor(Arcane.night)
            .padding(.horizontal, 24)
            .padding(.vertical, 12)
            .background(Capsule().fill(Arcane.gold))
        }
    }

    private var exampleBlock: some View {
        VStack(alignment: .leading, spacing: 10) {
            BiLabel(ja: "例文を試す", en: "Try an example", jaSize: 11, enSize: 10)
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 10) {
                    chip("I WILL BE CALM")
                    chip("SUCCESS IS MINE")
                    chip("I AM FEARLESS")
                    chip("PROTECT THIS HOME")
                    chip("CLARITY OF MIND")
                }
            }
        }
        .arcaneCard()
    }

    private func chip(_ text: String) -> some View {
        Button { intention = text } label: {
            Text(text)
                .font(.system(size: 12, weight: .medium, design: .serif))
                .foregroundColor(Arcane.goldBright)
                .padding(.horizontal, 14).padding(.vertical, 8)
                .background(Capsule().stroke(Arcane.gold.opacity(0.4), lineWidth: 1))
        }
    }

    @MainActor
    private func exportSigil() {
        let renderer = ImageRenderer(content:
            SigilGlyphView(reduced: reduced, showRings: showRings, showLetters: showLetters)
                .frame(width: 600, height: 600)
                .background(Arcane.night)
        )
        renderer.scale = 2.0
        guard let image = renderer.uiImage else { return }
        let av = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        guard let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let root = scene.windows.first(where: { $0.isKeyWindow })?.rootViewController else { return }
        av.popoverPresentationController?.sourceView = root.view
        root.present(av, animated: true)
    }
}

// MARK: - Sigil drawing

struct SigilGlyphView: View {
    let reduced: String
    var showRings: Bool = true
    var showLetters: Bool = false

    var body: some View {
        GeometryReader { geo in
            Canvas { context, size in
                let center = CGPoint(x: size.width / 2, y: size.height / 2)
                let radius = min(size.width, size.height) * 0.38

                if showRings {
                    // outer wheel
                    context.stroke(
                        Path(ellipseIn: CGRect(x: center.x - radius, y: center.y - radius,
                                               width: radius * 2, height: radius * 2)),
                        with: .color(Arcane.gold.opacity(0.3)), lineWidth: 1)
                    context.stroke(
                        Path(ellipseIn: CGRect(x: center.x - radius - 8, y: center.y - radius - 8,
                                               width: radius * 2 + 16, height: radius * 2 + 16)),
                        with: .color(Arcane.gold.opacity(0.15)), lineWidth: 0.6)

                    // 26 tick marks
                    for i in 0..<26 {
                        let a = -CGFloat.pi / 2 + CGFloat(i) / 26.0 * 2 * .pi
                        let p1 = CGPoint(x: center.x + cos(a) * radius, y: center.y + sin(a) * radius)
                        let p2 = CGPoint(x: center.x + cos(a) * (radius - 6), y: center.y + sin(a) * (radius - 6))
                        context.stroke(Path { p in p.move(to: p1); p.addLine(to: p2) },
                                       with: .color(Arcane.gold.opacity(0.2)), lineWidth: 0.6)
                    }
                }

                let pts = SigilData.wheelPoints(for: reduced, center: center, radius: radius)
                guard pts.count >= 1 else { return }

                if pts.count >= 2 {
                    var path = Path()
                    path.move(to: pts[0])
                    for p in pts.dropFirst() { path.addLine(to: p) }
                    context.stroke(path, with: .color(Arcane.goldBright),
                                   style: StrokeStyle(lineWidth: 2.4, lineCap: .round, lineJoin: .round))
                    // subtle glow underlay
                    context.stroke(path, with: .color(Arcane.crimson.opacity(0.35)),
                                   style: StrokeStyle(lineWidth: 6, lineCap: .round, lineJoin: .round))
                    context.stroke(path, with: .color(Arcane.goldBright),
                                   style: StrokeStyle(lineWidth: 2.4, lineCap: .round, lineJoin: .round))
                }

                // vertices
                for p in pts {
                    context.fill(Path(ellipseIn: CGRect(x: p.x - 2.5, y: p.y - 2.5, width: 5, height: 5)),
                                 with: .color(Arcane.goldBright))
                }

                // start marker: circle
                if let first = pts.first {
                    context.stroke(Path(ellipseIn: CGRect(x: first.x - 7, y: first.y - 7, width: 14, height: 14)),
                                   with: .color(Arcane.goldBright), lineWidth: 2)
                }
                // end marker: crossbar
                if pts.count >= 2, let last = pts.last {
                    let prev = pts[pts.count - 2]
                    let dx = last.x - prev.x, dy = last.y - prev.y
                    let len = max(sqrt(dx * dx + dy * dy), 0.001)
                    let nx = -dy / len, ny = dx / len
                    let barLen: CGFloat = 9
                    context.stroke(Path { p in
                        p.move(to: CGPoint(x: last.x - nx * barLen, y: last.y - ny * barLen))
                        p.addLine(to: CGPoint(x: last.x + nx * barLen, y: last.y + ny * barLen))
                    }, with: .color(Arcane.goldBright), lineWidth: 2.4)
                }
            }
            .overlay(letterLabels(in: geo.size))
        }
    }

    @ViewBuilder
    private func letterLabels(in size: CGSize) -> some View {
        if showLetters {
            let center = CGPoint(x: size.width / 2, y: size.height / 2)
            let radius = min(size.width, size.height) * 0.38 + 16
            ForEach(0..<26, id: \.self) { i in
                let a = -CGFloat.pi / 2 + CGFloat(i) / 26.0 * 2 * .pi
                let ch = Character(UnicodeScalar(65 + i)!)
                Text(String(ch))
                    .font(.system(size: 10, design: .serif))
                    .foregroundColor(reduced.contains(ch) ? Arcane.goldBright : Arcane.ash.opacity(0.5))
                    .position(x: center.x + cos(a) * radius, y: center.y + sin(a) * radius)
            }
        }
    }
}

#Preview { CreateView() }
