//
//  ScaledDimension.swift
//  MatchUp
//
//  Created by Muhammed Siddiqui on 7/10/24.
//

import Foundation
import UIKit

public class ScaledDimensions {
    
    static public var shared: ScaledDimensions = ScaledDimensions()
    
    private var designHeight: CGFloat = 812
    private var designWidth: CGFloat = 375
    private var screenHeight: CGFloat?
    private var screenWidth: CGFloat?
    
    init() {
        self.screenWidth = CGFloat(UIScreen.main.bounds.width)
        self.screenHeight = CGFloat(UIScreen.main.bounds.height)
    }
    
    public func setDesignSize(designHeight: CGFloat, designWidth: CGFloat) {
        self.designWidth = designWidth
        self.designHeight = designHeight
    }
    
    private func getScaleFactorWidth() -> CGFloat {
        return (self.screenWidth ?? 0) / self.designWidth
    }
    
    public func roundCGFloat(value: CGFloat, places: Int) -> CGFloat {
        let mod: CGFloat = pow(10.0, CGFloat(places))
        return (((value * mod).rounded()) / mod)
        
    }
    
    public func getScaledHeight(value: CGFloat) -> CGFloat {
        return roundCGFloat(value: (value * getScaleFactorWidth()),
                            places: 2)
    }
    
    public func getScaledWidth(value: CGFloat) -> CGFloat {
        return roundCGFloat(value: (value * getScaleFactorWidth()),
                            places: 2)
    }
    
    public func getScaledFontSize(value: CGFloat) -> CGFloat {
        return roundCGFloat(
            value: (value * getScaleFactorWidth()),
            places: 2)
    }
    
}
