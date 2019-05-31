//
//  ColorModel.swift
//  ARPool
//
//  Created by Marcus Vinicius Vieira Badiale on 31/05/19.
//  Copyright © 2019 Annderson Packeiser Oreto. All rights reserved.
//

import Foundation
import UIKit

enum ColorGame {
    case defaultGame
    case colorBlindGame
}

var color: ColorGame = .defaultGame

var colorGameRed: UIColor = UIColor.white
var colorGameBlue: UIColor = UIColor.white
var colorGameYellow: UIColor = UIColor.white


var red = UIColor(red: 1, green: 0.42, blue: 0.42, alpha: 1)
var blue = UIColor(red: 0.16, green: 0.77, blue: 0.81, alpha: 1)
var yellow = UIColor(red: 0.97, green: 0.94, blue: 0.53, alpha: 1)
var colorBlindRed = UIColor.red
var colorBlindBlue = UIColor.blue
var colorBlindYellow = UIColor.yellow

public func defineColorGame(){
    switch color{
    case .defaultGame:
        colorGameRed = red
        colorGameBlue = blue
        colorGameYellow = yellow
    case .colorBlindGame:
        colorGameRed = colorBlindRed
        colorGameBlue = colorBlindBlue
        colorGameYellow = colorBlindYellow
    }
}

