import AppKit

// Draws the app icon: "36" in Georgia on the app's plum, macOS only.
//
//   swiftc -O tool/icon.swift -o /tmp/icon
//   /tmp/icon 512 0.40 0 web/icons/Icon-512.png
//   /tmp/icon 192 0.40 0 web/icons/Icon-192.png
//   /tmp/icon 512 0.30 0 web/icons/Icon-maskable-512.png
//   /tmp/icon 192 0.30 0 web/icons/Icon-maskable-192.png
//   /tmp/icon 32 0.46 0.2 web/favicon.png
//
// Arguments: size in pixels, height of the digits as share of the size,
// corner radius as share of the size, output file. Maskable icons keep the
// digits inside the safe zone, because Android crops them to a circle; iOS
// rounds the corners of the others itself.
let args = CommandLine.arguments
let size = CGFloat(Double(args[1])!)
let textShare = CGFloat(Double(args[2])!)
let cornerShare = CGFloat(Double(args[3])!)
let out = args[4]

let rep = NSBitmapImageRep(bitmapDataPlanes: nil, pixelsWide: Int(size), pixelsHigh: Int(size),
  bitsPerSample: 8, samplesPerPixel: 4, hasAlpha: true, isPlanar: false,
  colorSpaceName: .deviceRGB, bytesPerRow: 0, bitsPerPixel: 0)!
NSGraphicsContext.saveGraphicsState()
NSGraphicsContext.current = NSGraphicsContext(bitmapImageRep: rep)
let plum = NSColor(srgbRed: 0x8C/255, green: 0x3B/255, blue: 0x5E/255, alpha: 1)
let paper = NSColor(srgbRed: 0xFF/255, green: 0xF8/255, blue: 0xF8/255, alpha: 1)
plum.setFill()
let r = size * cornerShare
NSBezierPath(roundedRect: NSRect(x: 0, y: 0, width: size, height: size), xRadius: r, yRadius: r).fill()

// Size the digits by their cap height, so "36" fills the same share at every size.
let probe = NSFont(name: "Georgia", size: 100)!
let font = NSFont(name: "Georgia", size: 100 * size * textShare / probe.capHeight)!
let text = NSAttributedString(string: "36", attributes: [.font: font, .foregroundColor: paper])

// Georgia has old-style figures ("3" drops below the baseline), so font
// metrics do not centre them: draw once, measure the ink, draw again.
func ink(_ rep: NSBitmapImageRep) -> (minX: Int, maxX: Int, minY: Int, maxY: Int) {
  var b = (minX: Int.max, maxX: -1, minY: Int.max, maxY: -1)
  for py in 0..<rep.pixelsHigh { for px in 0..<rep.pixelsWide {
    if rep.colorAt(x: px, y: py)!.greenComponent > 0.6 {
      b.minX = min(b.minX, px); b.maxX = max(b.maxX, px); b.minY = min(b.minY, py); b.maxY = max(b.maxY, py)
    }
  } }
  return b
}
let start = NSPoint(x: size / 4, y: size / 4)
text.draw(at: start)
let b = ink(rep)
// Bitmap rows count from the top, drawing coordinates from the bottom.
let dx = (size - CGFloat(b.maxX - b.minX + 1)) / 2 - CGFloat(b.minX)
let dy = CGFloat(b.minY) - (size - CGFloat(b.maxY - b.minY + 1)) / 2
plum.setFill()
NSBezierPath(roundedRect: NSRect(x: 0, y: 0, width: size, height: size), xRadius: r, yRadius: r).fill()
text.draw(at: NSPoint(x: start.x + dx, y: start.y + dy))
NSGraphicsContext.restoreGraphicsState()
try! rep.representation(using: .png, properties: [:])!.write(to: URL(fileURLWithPath: out))
