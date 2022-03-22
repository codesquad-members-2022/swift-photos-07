import Foundation

struct Color {

    static func generateRandom() -> (Double, Double, Double, Double) {
        let red = Double.random(in: ColorRange.lower...ColorRange.upper)
        let green = Double.random(in: ColorRange.lower...ColorRange.upper)
        let blue = Double.random(in: ColorRange.lower...ColorRange.upper)
        let alpha = ColorRange.defaultAlpha
        
        return (red, green, blue, alpha)
    }
}
