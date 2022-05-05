//
//  GradientCreator.swift
//  Moneybox
//
//  Created by Fernando Ives on 04/05/22.
//

import UIKit

final class Utilities {
    static func makeGradient(topColor: UIColor, bottomColor: UIColor) -> CAGradientLayer {
        let colorTop =  topColor.cgColor
        let colorBottom = bottomColor.cgColor
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [colorTop, colorBottom]
        gradientLayer.locations = [0.0, 1.0]
        return gradientLayer
    }
}
