//
//  ColorBlindGenerator.swift
//  FinalProject
//
//  Created by Zhen on 3/20/18.
//  Copyright © 2018 Local Account 436-30. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
    convenience init?(hexRGBA: String?) {
        guard let rgba = hexRGBA, let val = Int(rgba, radix: 16) else {
            return nil
        }
        self.init(red: CGFloat((val >> 24) & 0xff) / 255.0, green: CGFloat((val >> 16) & 0xff) / 255.0, blue: CGFloat((val >> 8) & 0xff) / 255.0, alpha: CGFloat(val & 0xff) / 255.0)
    }
    
    func rgba() -> RGBA? {
        var fRed : CGFloat = 0
        var fGreen : CGFloat = 0
        var fBlue : CGFloat = 0
        var fAlpha: CGFloat = 0
        if self.getRed(&fRed, green: &fGreen, blue: &fBlue, alpha: &fAlpha) {
            return RGBA(R: Float(fRed), G: Float(fGreen), B: Float(fBlue), A: Float(fAlpha))
        } else {
            // Could not extract RGBA components:
            return nil
        }
    }
}

class ColorBlindGenerator {
    let normal : [Float] = [
        1.000, 0.000, 0.000, 0.000, // R
        0.000, 1.000, 0.000, 0.000, // G
        0.000, 0.000, 1.000, 0.000, // B
        0.000, 0.000, 0.000, 1.000  // A
    ]
    let protanopia : [Float] = [
        0.567, 0.433, 0.000, 0.000, // R
        0.558, 0.442, 0.000, 0.000, // G
        0.000, 0.242, 0.758, 0.000, // B
        0.000, 0.000, 0.000, 1.000  // A
    ]
    let protanomaly : [Float] = [
        0.817, 0.183, 0.000, 0.000, // R
        0.333, 0.667, 0.000, 0.000, // G
        0.000, 0.125, 0.875, 0.000, // B
        0.000, 0.000, 0.000, 1.000  // A
    ]
    let deuteranopia : [Float] = [
        0.625, 0.375, 0.000, 0.000, // R
        0.700, 0.300, 0.000, 0.000, // G
        0.000, 0.300, 0.700, 0.000, // B
        0.000, 0.000, 0.000, 1.000  // A
    ]
    let deuteranomaly : [Float] = [
        0.800, 0.200, 0.000, 0.000, // R
        0.258, 0.742, 0.000, 0.000, // G
        0.000, 0.142, 0.858, 0.000, // B
        0.000, 0.000, 0.000, 1.000  // A
    ]
    let tritanopia : [Float] = [
        0.950, 0.050, 0.000, 0.000, // R
        0.000, 0.433, 0.567, 0.000, // G
        0.000, 0.475, 0.525, 0.000, // B
        0.000, 0.000, 0.000, 1.000  // A
    ]
    let tritanomaly : [Float] = [
        0.967, 0.033, 0.000, 0.000, // R
        0.000, 0.733, 0.267, 0.000, // G
        0.000, 0.183, 0.817, 0.000, // B
        0.000, 0.000, 0.000, 1.000  // A
    ]
    let achromatopsia : [Float] = [
        0.299, 0.587, 0.114, 0.000, // R
        0.299, 0.587, 0.114, 0.000, // G
        0.299, 0.587, 0.114, 0.000, // B
        0.000, 0.000, 0.000, 1.000  // A
    ]
    let achromatomaly : [Float] = [
        0.618, 0.320, 0.062, 0.000, // R
        0.163, 0.775, 0.062, 0.000, // G
        0.163, 0.320, 0.516, 0.000, // B
        0.000, 0.000, 0.000, 1.000  // A
    ]
    
    func colorBlindType(_ type: String) -> [Float] {
        var matrix: [Float]
        switch (type) {
        case "protanopia":
            matrix = protanopia
        case "protanomaly":
            matrix = protanomaly
        case "deuteranopia":
            matrix = deuteranopia
        case "deuteranomaly":
            matrix = deuteranomaly
        case "tritanopia":
            matrix = tritanopia
        case "tritanomaly":
            matrix = tritanomaly
        case "achromatopsia":
            matrix = achromatopsia
        case "achromatomaly":
            matrix = achromatomaly
        default:
            matrix = normal
        }
        return matrix
    }
    
    func colorConvert(color: UIColor, type: String) -> UIColor {
        let matrix = colorBlindType(type)
        let rgba = color.rgba()
        
        var subred, subgreen, subblue, subalpha : Float
        subred = rgba!.R * matrix[0]
        subgreen = rgba!.G * matrix[1]
        subblue = rgba!.B * matrix[2]
        subalpha = rgba!.A * matrix[3]
        let R = subred + subgreen + subblue + subalpha
        
        subred = rgba!.R * matrix[4]
        subgreen = rgba!.G * matrix[5]
        subblue = rgba!.B * matrix[6]
        subalpha = rgba!.A * matrix[7]
        let G = subred + subgreen + subblue + subalpha
        
        subred = rgba!.R * matrix[8]
        subgreen = rgba!.G * matrix[9]
        subblue = rgba!.B * matrix[10]
        subalpha = rgba!.A * matrix[11]
        let B = subred + subgreen + subblue + subalpha
        
        subred = rgba!.R * matrix[12]
        subgreen = rgba!.G * matrix[13]
        subblue = rgba!.B * matrix[14]
        subalpha = rgba!.A * matrix[15]
        let A = subred + subgreen + subblue + subalpha
        
        return UIColor(red: CGFloat(R), green: CGFloat(G), blue: CGFloat(B), alpha: CGFloat(A))
    }
}
