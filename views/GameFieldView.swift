//
//  GameFieldView.swift
//  views
//
//  Created by Roman on 10/09/2019.
//  Copyright © 2019 Roman. All rights reserved.
//

// файл с ручной отрисовкой представления фигуры

import UIKit

class GameFielView: UIView {
    var shapeColor: UIColor = .red
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        shapeColor.setFill()
        
    }
    
}
