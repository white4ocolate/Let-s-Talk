//
//  GradientView.swift
//  MyChat
//
//  Created by white4ocolate on 23.04.2024.
//

import UIKit

class GradientView: UIView {
    
    // @IBInspectable need if we want to choos start color and end color in Storyboard
    @IBInspectable private var startColor: UIColor? {
        didSet {
            setupGradientColors(startColor: startColor, endColor: endColor)
        }
    }

    @IBInspectable private var endColor: UIColor? {
        didSet {
            setupGradientColors(startColor: startColor, endColor: endColor)
        }
    }
    
    private let gradientLayer = CAGradientLayer()
    
    enum Point {
        case topLeading
        case top
        case topTrailing
        case bottomLeading
        case bottom
        case bottomTrailing
        case leading
        case trailing
        case center
        
        var point: CGPoint{
            switch self {
            case .topLeading:
                return CGPoint(x: 0, y: 0)
            case .top:
                return CGPoint(x: 0.5, y: 0)
            case .topTrailing:
                return CGPoint(x: 1.0, y: 0)
            case .bottomLeading:
                return CGPoint(x: 0, y: 1.0)
            case .bottom:
                return CGPoint(x: 0.5, y: 1.0)
            case .bottomTrailing:
                return CGPoint(x: 1.0, y: 1.0)
            case .leading:
                return CGPoint(x: 0, y: 0.5)
            case .trailing:
                return CGPoint(x: 1, y: 0.5)
            case .center:
                return CGPoint(x: 0.5, y: 0.5)
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    init(from: Point, to: Point, startColor: UIColor?, endColor: UIColor?) {
        self.init()
        setupGradient(from: from, to: to, startColor: startColor, endColor: endColor)
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = self.bounds
    }
    
    private func setupGradient(from: Point, to: Point, startColor: UIColor?, endColor: UIColor?) {
        self.layer.addSublayer(gradientLayer)
        setupGradientColors(startColor: startColor, endColor: endColor)
        gradientLayer.startPoint = from.point
        gradientLayer.endPoint = to.point
    }
    
    fileprivate func setupGradientColors( startColor: UIColor?, endColor: UIColor?) {
        if let startColor = startColor, let endColor = endColor {
            gradientLayer.colors = [startColor.cgColor, endColor.cgColor]
        }
    }
    
    //Now gradient available in Interface Builder
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupGradient(from: .topTrailing, to: .bottomLeading, startColor: startColor, endColor: endColor)
    }
}
