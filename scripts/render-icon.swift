import AppKit
import CoreGraphics
import Foundation

let size = 1024
guard let colorSpace = CGColorSpace(name: CGColorSpace.sRGB),
      let ctx = CGContext(data: nil, width: size, height: size, bitsPerComponent: 8, bytesPerRow: 0, space: colorSpace, bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue) else {
    fatalError("Failed to create CGContext")
}

ctx.setAllowsAntialiasing(true)
ctx.setShouldAntialias(true)
ctx.interpolationQuality = .high

let bounds = CGRect(x: 0, y: 0, width: size, height: size)

// 1. macOS Squircle Container
let iconPadding: CGFloat = 100
let iconRect = bounds.insetBy(dx: iconPadding, dy: iconPadding)
let cornerRadius: CGFloat = 185

func squirclePath(rect: CGRect, radius: CGFloat) -> CGPath {
    return CGPath(roundedRect: rect, cornerWidth: radius, cornerHeight: radius, transform: nil)
}

let baseSquircle = squirclePath(rect: iconRect, radius: cornerRadius)

// Squircle Drop Shadow
ctx.saveGState()
ctx.setShadow(offset: CGSize(width: 0, height: -24), blur: 36, color: CGColor(red: 0, green: 0, blue: 0, alpha: 0.50))
ctx.addPath(baseSquircle)
ctx.setFillColor(CGColor(red: 0.05, green: 0.08, blue: 0.16, alpha: 1.0))
ctx.fillPath()
ctx.restoreGState()

// Clip inside squircle
ctx.saveGState()
ctx.addPath(baseSquircle)
ctx.clip()

// 2. Background Gradient (Deep Navy to Indigo Space)
let bgColors = [
    CGColor(red: 0.09, green: 0.13, blue: 0.26, alpha: 1.0), // #172142
    CGColor(red: 0.04, green: 0.06, blue: 0.12, alpha: 1.0)  // #0A0F1F
] as CFArray
if let bgGradient = CGGradient(colorsSpace: colorSpace, colors: bgColors, locations: [0.0, 1.0]) {
    ctx.drawLinearGradient(bgGradient, start: CGPoint(x: iconRect.midX, y: iconRect.maxY), end: CGPoint(x: iconRect.midX, y: iconRect.minY), options: [])
}

// Radiant ambient glow in center
let glowColors = [
    CGColor(red: 0.16, green: 0.42, blue: 0.88, alpha: 0.30),
    CGColor(red: 0.05, green: 0.15, blue: 0.45, alpha: 0.0)
] as CFArray
if let centerGlow = CGGradient(colorsSpace: colorSpace, colors: glowColors, locations: [0.0, 1.0]) {
    ctx.drawRadialGradient(centerGlow, startCenter: CGPoint(x: 512, y: 520), startRadius: 20, endCenter: CGPoint(x: 512, y: 520), endRadius: 380, options: [])
}

// 3. Elegant Network Latitude / Orbital Rings in Background
ctx.saveGState()
ctx.setLineWidth(1.5)
ctx.setStrokeColor(CGColor(red: 0.40, green: 0.65, blue: 1.0, alpha: 0.14))

let globeCenter = CGPoint(x: 512, y: 490)
for (rx, ry) in [(280.0, 130.0), (340.0, 160.0), (390.0, 185.0)] as [(CGFloat, CGFloat)] {
    ctx.strokeEllipse(in: CGRect(x: globeCenter.x - rx, y: globeCenter.y - ry, width: rx * 2, height: ry * 2))
}

// Subtle network nodes on rings
let bgNodes = [
    CGPoint(x: 232, y: 490),
    CGPoint(x: 792, y: 490),
    CGPoint(x: 320, y: 590),
    CGPoint(x: 704, y: 590),
    CGPoint(x: 400, y: 360),
    CGPoint(x: 624, y: 360)
]
for pt in bgNodes {
    ctx.setFillColor(CGColor(red: 0.4, green: 0.7, blue: 1.0, alpha: 0.28))
    ctx.fillEllipse(in: CGRect(x: pt.x - 3, y: pt.y - 3, width: 6, height: 6))
}
ctx.restoreGState()

// 4. Smooth, Plump 3D Antigravity Arch
// Beautiful organic Gaussian arch matching Antigravity's signature visual geometry
func createSmoothArchPath() -> CGPath {
    let path = CGMutablePath()
    
    // Outer Curve
    // Left Foot rounded bottom tip
    path.move(to: CGPoint(x: 235, y: 300))
    path.addCurve(to: CGPoint(x: 300, y: 325), control1: CGPoint(x: 230, y: 260), control2: CGPoint(x: 275, y: 275))
    // Left outer flank curving up to smooth rounded dome peak
    path.addCurve(to: CGPoint(x: 430, y: 680), control1: CGPoint(x: 350, y: 390), control2: CGPoint(x: 385, y: 545))
    // Smooth rounded dome crest at apex
    path.addCurve(to: CGPoint(x: 594, y: 680), control1: CGPoint(x: 470, y: 740), control2: CGPoint(x: 554, y: 740))
    // Right outer flank curving down
    path.addCurve(to: CGPoint(x: 724, y: 325), control1: CGPoint(x: 639, y: 545), control2: CGPoint(x: 674, y: 390))
    // Right Foot rounded bottom tip
    path.addCurve(to: CGPoint(x: 789, y: 300), control1: CGPoint(x: 749, y: 275), control2: CGPoint(x: 794, y: 260))
    // Right inner flank curving up
    path.addCurve(to: CGPoint(x: 580, y: 460), control1: CGPoint(x: 745, y: 375), control2: CGPoint(x: 660, y: 430))
    // Smooth rounded inner arch ceiling
    path.addCurve(to: CGPoint(x: 444, y: 460), control1: CGPoint(x: 540, y: 485), control2: CGPoint(x: 484, y: 485))
    // Left inner flank curving down to left foot
    path.addCurve(to: CGPoint(x: 235, y: 300), control1: CGPoint(x: 364, y: 430), control2: CGPoint(x: 279, y: 375))
    
    path.closeSubpath()
    return path
}

let archPath = createSmoothArchPath()

// Arch drop shadow
ctx.saveGState()
ctx.setShadow(offset: CGSize(width: 0, height: -18), blur: 30, color: CGColor(red: 0, green: 0, blue: 0, alpha: 0.65))
ctx.addPath(archPath)
ctx.setFillColor(CGColor(red: 0.1, green: 0.15, blue: 0.3, alpha: 1.0))
ctx.fillPath()
ctx.restoreGState()

// Fill Arch with authentic Google-gradient
ctx.saveGState()
ctx.addPath(archPath)
ctx.clip()

let archColors = [
    CGColor(red: 0.10, green: 0.45, blue: 0.95, alpha: 1.0), // Electric Blue #1A73E8 (Left Foot)
    CGColor(red: 0.00, green: 0.85, blue: 0.45, alpha: 1.0), // Emerald Green #00E676 (Left Flank)
    CGColor(red: 1.00, green: 0.73, blue: 0.02, alpha: 1.0), // Warm Sun Yellow #FFBB05 (Left Crest)
    CGColor(red: 0.96, green: 0.26, blue: 0.16, alpha: 1.0), // Coral Red #F44336 (Right Crest)
    CGColor(red: 0.18, green: 0.50, blue: 0.98, alpha: 1.0)  // Sky Blue #2E80FA (Right Foot)
] as CFArray
let archLocations: [CGFloat] = [0.0, 0.28, 0.48, 0.68, 1.0]
if let archGrad = CGGradient(colorsSpace: colorSpace, colors: archColors, locations: archLocations) {
    ctx.drawLinearGradient(archGrad, start: CGPoint(x: 235, y: 320), end: CGPoint(x: 790, y: 320), options: [])
}

// 3D Volumetric Lighting / Ambient Occlusion overlay on Arch
let arch3DColors = [
    CGColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.32), // top rim highlight
    CGColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.0),
    CGColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.35)  // bottom depth
] as CFArray
if let arch3DGrad = CGGradient(colorsSpace: colorSpace, colors: arch3DColors, locations: [0.0, 0.45, 1.0]) {
    ctx.drawLinearGradient(arch3DGrad, start: CGPoint(x: 512, y: 740), end: CGPoint(x: 512, y: 270), options: [])
}
ctx.restoreGState()

// Arch subtle inner border for glassmorphic/clay edge
ctx.saveGState()
ctx.addPath(archPath)
ctx.setLineWidth(2.5)
ctx.setStrokeColor(CGColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.35))
ctx.strokePath()
ctx.restoreGState()

// 5. Dynamic Proxy Routing Pipeline
let p0 = CGPoint(x: 300, y: 345) // Start Node
let p1 = CGPoint(x: 410, y: 355)
let p2 = CGPoint(x: 470, y: 505)
let p3 = CGPoint(x: 535, y: 535) // Gateway crossing
let p4 = CGPoint(x: 615, y: 565)
let p5 = CGPoint(x: 695, y: 645) // Arrow base attachment point

let pipeline = CGMutablePath()
pipeline.move(to: p0)
pipeline.addCurve(to: p3, control1: p1, control2: p2)
pipeline.addCurve(to: p5, control1: p4, control2: CGPoint(x: 660, y: 610))

// A. Ambient shadow cast by the pipeline onto the arch and background
ctx.saveGState()
ctx.setShadow(offset: CGSize(width: -6, height: -12), blur: 18, color: CGColor(red: 0, green: 0, blue: 0, alpha: 0.40))
ctx.setLineWidth(32)
ctx.setLineCap(.round)
ctx.addPath(pipeline)
ctx.setStrokeColor(CGColor(red: 0, green: 0, blue: 0, alpha: 0.40))
ctx.strokePath()
ctx.restoreGState()

// B. Glowing ambient halo around the proxy pipeline
ctx.saveGState()
ctx.setShadow(offset: CGSize(width: 0, height: 4), blur: 24, color: CGColor(red: 1.0, green: 0.45, blue: 0.0, alpha: 0.90))
ctx.setLineWidth(36)
ctx.setLineCap(.round)
ctx.addPath(pipeline)
ctx.setStrokeColor(CGColor(red: 1.0, green: 0.50, blue: 0.0, alpha: 0.85))
ctx.strokePath()
ctx.restoreGState()

// C. Main 3D Pipe Body (Warm Tangerine / Orange Gradient)
ctx.saveGState()
ctx.setLineWidth(28)
ctx.setLineCap(.round)
ctx.addPath(pipeline)
ctx.setStrokeColor(CGColor(red: 1.0, green: 0.58, blue: 0.05, alpha: 1.0))
ctx.strokePath()

// D. Specular Core Highlight along pipeline
ctx.setLineWidth(10)
ctx.setLineCap(.round)
ctx.addPath(pipeline)
ctx.setStrokeColor(CGColor(red: 1.0, green: 0.93, blue: 0.75, alpha: 0.95))
ctx.strokePath()
ctx.restoreGState()

// 6. Bold 3D Modern Arrow Head at route destination
ctx.saveGState()

let arrowAngle: CGFloat = 42.0 * .pi / 180.0
let arrowH: CGFloat = 90
let arrowW: CGFloat = 84
let arrowIndent: CGFloat = 24

// Position the arrow so its inner notch snugly attaches to p5
let arrowTipX = p5.x + cos(arrowAngle) * 44
let arrowTipY = p5.y + sin(arrowAngle) * 44

ctx.translateBy(x: arrowTipX, y: arrowTipY)
ctx.rotate(by: arrowAngle)

let arrow = CGMutablePath()
arrow.move(to: CGPoint(x: arrowH / 2, y: 0)) // Tip
arrow.addLine(to: CGPoint(x: -arrowH / 2, y: arrowW / 2)) // Top barb
arrow.addLine(to: CGPoint(x: -arrowH / 2 + arrowIndent, y: 0)) // Inner notch
arrow.addLine(to: CGPoint(x: -arrowH / 2, y: -arrowW / 2)) // Bottom barb
arrow.closeSubpath()

// Arrow drop shadow
ctx.setShadow(offset: CGSize(width: -8, height: -10), blur: 20, color: CGColor(red: 0, green: 0, blue: 0, alpha: 0.55))
ctx.addPath(arrow)
ctx.setFillColor(CGColor(red: 1.0, green: 0.55, blue: 0.05, alpha: 1.0))
ctx.fillPath()

// Arrow 3D gradient fill
ctx.saveGState()
ctx.addPath(arrow)
ctx.clip()
let arrowGradColors = [
    CGColor(red: 1.0, green: 0.82, blue: 0.32, alpha: 1.0), // Bright golden tip
    CGColor(red: 1.0, green: 0.48, blue: 0.00, alpha: 1.0)  // Deep tangerine base
] as CFArray
if let aGrad = CGGradient(colorsSpace: colorSpace, colors: arrowGradColors, locations: [0.0, 1.0]) {
    ctx.drawLinearGradient(aGrad, start: CGPoint(x: arrowH / 2, y: 0), end: CGPoint(x: -arrowH / 2, y: 0), options: [])
}
ctx.restoreGState()

// Arrow bevel highlight
ctx.setShadow(offset: .zero, blur: 0, color: nil)
ctx.addPath(arrow)
ctx.setLineWidth(3.5)
ctx.setStrokeColor(CGColor(red: 1.0, green: 0.95, blue: 0.80, alpha: 0.90))
ctx.strokePath()

ctx.restoreGState()

// 7. Proxy Origin Node (Glowing multi-layer concentric beacon)
ctx.saveGState()
// Outer pulse ring
ctx.setLineWidth(3.5)
ctx.setStrokeColor(CGColor(red: 1.0, green: 0.65, blue: 0.1, alpha: 0.45))
ctx.strokeEllipse(in: CGRect(x: p0.x - 38, y: p0.y - 38, width: 76, height: 76))

// Middle glow ring
ctx.setLineWidth(4.0)
ctx.setStrokeColor(CGColor(red: 1.0, green: 0.75, blue: 0.2, alpha: 0.80))
ctx.strokeEllipse(in: CGRect(x: p0.x - 26, y: p0.y - 26, width: 52, height: 52))

// Center 3D sphere node
ctx.setShadow(offset: CGSize(width: 0, height: 6), blur: 16, color: CGColor(red: 1.0, green: 0.4, blue: 0.0, alpha: 0.8))
let coreNodeRect = CGRect(x: p0.x - 20, y: p0.y - 20, width: 40, height: 40)
ctx.addEllipse(in: coreNodeRect)
ctx.setFillColor(CGColor(red: 1.0, green: 0.60, blue: 0.05, alpha: 1.0))
ctx.fillPath()

// 3D Spherical Specular Glare
let glareRect = CGRect(x: p0.x - 12, y: p0.y + 2, width: 14, height: 14)
ctx.addEllipse(in: glareRect)
ctx.setFillColor(CGColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.90))
ctx.fillPath()
ctx.restoreGState()

// 8. Floating Network Data Packets along the route
let packetPoints = [
    CGPoint(x: 460, y: 485),
    CGPoint(x: 620, y: 570)
]

for pt in packetPoints {
    ctx.saveGState()
    ctx.setShadow(offset: CGSize(width: 0, height: 2), blur: 10, color: CGColor(red: 1.0, green: 0.85, blue: 0.3, alpha: 0.9))
    ctx.addEllipse(in: CGRect(x: pt.x - 9, y: pt.y - 9, width: 18, height: 18))
    ctx.setFillColor(CGColor(red: 1.0, green: 0.88, blue: 0.4, alpha: 1.0))
    ctx.fillPath()
    
    ctx.addEllipse(in: CGRect(x: pt.x - 4, y: pt.y - 2, width: 8, height: 8))
    ctx.setFillColor(CGColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.95))
    ctx.fillPath()
    ctx.restoreGState()
}

// 9. Subtle macOS Squircle Border / Inner Bevel
ctx.saveGState()
ctx.addPath(baseSquircle)
ctx.setLineWidth(3.0)
let borderColors = [
    CGColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.30),
    CGColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.06),
    CGColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.45)
] as CFArray
if let borderGrad = CGGradient(colorsSpace: colorSpace, colors: borderColors, locations: [0.0, 0.5, 1.0]) {
    ctx.replacePathWithStrokedPath()
    ctx.clip()
    ctx.drawLinearGradient(borderGrad, start: CGPoint(x: iconRect.midX, y: iconRect.maxY), end: CGPoint(x: iconRect.midX, y: iconRect.minY), options: [])
}
ctx.restoreGState()

ctx.restoreGState() // unclip squircle

// 10. Save output
guard let img = ctx.makeImage() else { fatalError("makeImage failed") }
let rep = NSBitmapImageRep(cgImage: img)
guard let pngData = rep.representation(using: .png, properties: [:]) else { fatalError("png representation failed") }
try pngData.write(to: URL(fileURLWithPath: "/tmp/antigravity_preview.png"))
print("RENDERED_SUCCESSFULLY")
