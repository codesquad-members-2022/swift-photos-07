import UIKit

struct ColorFactory {
    private static func generateRandom() -> UIColor {
        let red = Double.random(in: ColorRange.lower...ColorRange.upper)
        let green = Double.random(in: ColorRange.lower...ColorRange.upper)
        let blue = Double.random(in: ColorRange.lower...ColorRange.upper)
        let alpha = ColorRange.defaultAlpha
        
        return UIColor(red: red, green: green, blue: blue, alpha: alpha)
    }
    
    static func generateRandom(count: Int) -> [UIColor] {
        var colors: [UIColor] = []
        (0..<count).forEach { _ in
            colors.append(ColorFactory.generateRandom())
        }
        return colors
    }
}
