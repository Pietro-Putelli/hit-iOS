//
//  SegmentControl.swift
//  searchBar
//
//  Created by Pietro Putelli on 04/08/2020.
//  Copyright © 2020 Pietro Putelli. All rights reserved.
//

import UIKit

protocol SegmentControlDelegate: class {
    func moveScrollView(for index: Int)
}

class SegmentControl: UIControl {
    
    // MARK: - Proprieties
    
    var buttons = [UIButton]()
    var selector: UIView!
    
    weak var delegate: SegmentControlDelegate?
    
    var selectedSegmentIndex = 0
    
    var borderWidth: CGFloat = 0 {
        didSet {
            layer.borderWidth = borderWidth
        }
    }
    
    var cornerRadius: CGFloat = 0 {
        didSet {
            layer.cornerRadius = cornerRadius
        }
    }
    
    var borderColor: UIColor = .clear {
        didSet {
            layer.borderColor = borderColor.cgColor
        }
    }
    
    var images: [UIImage] = [] {
        didSet {
            updateView()
        }
    }
    
    var titles: [String] = [] {
        didSet {
            updateView()
        }
    }
    
    var textColor: UIColor = .perla {
        didSet {
            updateView()
        }
    }
    
    var selectorColor: UIColor = .irisPurple {
        didSet {
            updateView()
        }
    }
    
    var selectedTextColor: UIColor = .perla {
        didSet {
            updateView()
        }
    }
    
    var unselectedTextColor: UIColor = .white(alpha: 0.6)
    
    var selectorWidth: CGFloat {
        return frame.width / 4
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        updateView()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        updateView()
    }
    
    // MARK: - Setup
    
    private func updateView() {
        buttons.removeAll()
        subviews.forEach { (view) in
            view.removeFromSuperview()
        }
        
        guard !images.isEmpty else {
            for title in titles {
                let button = UIButton(type: .system)
                button.setTitle(title, for: .normal)
                button.setTitleColor(textColor, for: .normal)
                button.titleLabel?.font = Fonts.Main.withSize(18)
                button.addTarget(self, action: #selector(buttonTapped(button:)), for: .touchUpInside)
                buttons.append(button)
            }
            
            setup()
            return
        }
        
        for image in images {
            let button = UIButton.init(type: .system)

            button.setImage(image, for: .normal)
            button.tintColor = textColor
            button.titleLabel?.font = Fonts.Main.withSize(18)
            button.addTarget(self, action: #selector(buttonTapped(button:)), for: .touchUpInside)
            buttons.append(button)
        }
        setup()
    }
    
    private func setup() {
        buttons.first?.tintColor = selectedTextColor
        buttons.last?.tintColor = unselectedTextColor
        
        let selectorHeight: CGFloat = 1.0
        
        let y = (self.frame.maxY - self.frame.minY) - selectorHeight

        selector = UIView.init(frame: .init(x: selectorWidth / 2, y: y, width: selectorWidth, height: selectorHeight))
        selector.backgroundColor = selectorColor.withAlphaComponent(0.5)
        addSubview(selector)
        
        let stackView = UIStackView.init(arrangedSubviews: buttons)
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.spacing = 0.0
        addSubview(stackView)
        
        clipsToBounds = true

        stackView.fillSuperview()
    }
    
    @objc func buttonTapped(button: UIButton) {
        for (buttonIndex,btn) in buttons.enumerated() {
            btn.tintColor = unselectedTextColor
            
            if btn == button {
                button.tintColor = selectedTextColor
                delegate?.moveScrollView(for: buttonIndex)
                selectedSegmentIndex = buttonIndex
                
                let selectorStartPosition = frame.width / CGFloat(buttons.count) * CGFloat(buttonIndex)

                UIView.animate(withDuration: 0.3, animations: {
                    self.selector.frame.origin.x = selectorStartPosition + self.selectorWidth / 2
                })
            }
        }
        sendActions(for: .valueChanged)
    }
    
    func moveSelector(translateByX: CGFloat) {
        selector.frame.origin.x = translateByX + self.selectorWidth / 2
        updateSelectedIndex()
    }
    
    func updateSelectedIndex() {
        if selector.center.x < frame.width / 2 {
            selectedSegmentIndex = 0
        } else {
            selectedSegmentIndex = 1
        }
        
        for btn in buttons {
            UIView.animate(withDuration: 0.1) {
                btn.tintColor = self.unselectedTextColor
                btn.titleColor(self.unselectedTextColor)
            }
        }
        let button = buttons[selectedSegmentIndex]
        UIView.animate(withDuration: 0.1) {
            button.tintColor = self.selectedTextColor
            button.titleColor(self.selectedTextColor)
        }
    }
    
    func updateSegmentedControlSegs(index: Int) {
        for btn in buttons {
            btn.tintColor = unselectedTextColor
        }
        
        let selectorStartPosition = frame.width / CGFloat(buttons.count) * CGFloat(index)

        UIView.animate(withDuration: 0.3, animations: {
            self.selector.frame.origin.x = selectorStartPosition + self.selectorWidth / 2
        })
        
        buttons[index].tintColor = selectedTextColor
        selectedSegmentIndex = index
    }

    func moveSegmentControl(to index: Int) {
        updateSegmentedControlSegs(index: index)
    }
}
