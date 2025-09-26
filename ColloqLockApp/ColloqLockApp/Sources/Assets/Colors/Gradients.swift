import UIKit
import SwiftUI

enum GradientColors {
    static let gradientColorsUIKit: [UIColor] = [
        UIColors.backgroundSecondary,
        UIColors.backgroundPrimary
    ]
    
    static let gradientColorsSUI: [Color] = gradientColorsUIKit.map { Color($0) }
    
}

enum GradientLocations {
    static let gradientLocations: [CGFloat] = [
        0.0,
        0.35
    ]
}

extension LinearGradient {
    static var appBackground: LinearGradient {
        let stops: [Gradient.Stop] = zip(
            GradientColors.gradientColorsSUI,
            GradientLocations.gradientLocations
        ).map { color, location in
            Gradient.Stop(color: color, location: location)
        }
        
        return LinearGradient(
            gradient: Gradient(stops: stops),
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
    
    static var appBackgroundReverse: LinearGradient {
        let stops: [Gradient.Stop] = zip(
            GradientColors.gradientColorsSUI,
            GradientLocations.gradientLocations
        ).map { color, location in
            Gradient.Stop(color: color, location: location)
        }
        
        return LinearGradient(
            gradient: Gradient(stops: stops),
            startPoint: .bottomTrailing,
            endPoint: .topLeading
        )
    }
}


extension CAGradientLayer {
    static var appBackground: CAGradientLayer {
        let gradient = CAGradientLayer()
        gradient.colors = GradientColors.gradientColorsUIKit.map { $0.cgColor }
        gradient.locations = GradientLocations.gradientLocations.map { NSNumber(value: Float($0)) }
        
        gradient.startPoint = CGPoint(x: 0.5, y: -0.1)
        gradient.endPoint = CGPoint(x: 0.8, y: 1)
        return gradient
    }
    
    static var appBackgroundReverse: CAGradientLayer {
        let gradient = CAGradientLayer()
        gradient.colors = GradientColors.gradientColorsUIKit.map { $0.cgColor }
        gradient.locations = GradientLocations.gradientLocations.map { NSNumber(value: Float($0)) }
            
        gradient.startPoint = CGPoint(x: 0.8, y: 1)
        gradient.endPoint = CGPoint(x: 0.5, y: -0.1)
        return gradient
    }
}
