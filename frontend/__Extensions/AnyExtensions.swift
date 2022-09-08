//
//  Extensions.swift
//  Hit
//
//  Created by Pietro Putelli on 15/12/2019.
//  Copyright © 2019 Pietro Putelli. All rights reserved.
//

import UIKit

extension UIAlertAction {
    func setTextColor(for color: UIColor) {
        setValue(color, forKey: "titleTextColor")
    }
}

extension UIAlertController {
    func addActions(_ actions: [UIAlertAction]) {
        for action in actions {
            addAction(action)
        }
    }
}

extension UINavigationBar {
    open override func sizeThatFits(_ size: CGSize) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width, height: 100)
    }
    
    func setTitleFont(for font: UIFont) {
        titleTextAttributes = [NSAttributedString.Key.font: font]
    }
}

extension UITextField {
    
    func makeBottomBorder() {
        let border = CALayer()
        let width = CGFloat(0.3)
        border.borderColor = UIColor.white.cgColor
        border.frame = CGRect(x: 0, y: frame.size.height - width, width: frame.size.width, height: frame.size.height)
        
        borderStyle = .none
        
        border.borderWidth = width
        border.borderColor = UIColor.white.cgColor
        layer.masksToBounds = true
        layer.addSublayer(border)
    }

    func shake() {
        let animation = CABasicAnimation(keyPath: "position")
        animation.duration = 0.07
        animation.repeatCount = 4
        animation.autoreverses = true
        animation.fromValue = CGPoint(x: center.x - 10, y: center.y)
        animation.toValue = CGPoint(x: center.x + 10, y: center.y)
        
        layer.add(animation, forKey: "position")
    }
    
    func setRightViewIcon(icon: UIImage) {
        let btnView = UIButton(frame: CGRect(x: 0, y: 0, width: ((self.frame.height) * 0.70), height: ((self.frame.height) * 0.70)))
        btnView.setImage(icon, for: .normal)
        btnView.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        btnView.tintColor = UIColor.white.withAlphaComponent(0.5)
        
        rightViewMode = .whileEditing
        rightView = btnView
    }
    
    var rightButton: UIButton {
        return rightView as! UIButton
    }
    
    func cleanup() {
        text = nil
    }
}

extension NSMutableData {
    func appendString(string: String) {
        let data = string.data(using: String.Encoding.utf8, allowLossyConversion: true)
        append(data!)
    }
}

extension CGFloat {
    static var screenWidth: CGFloat {
        return UIScreen.main.bounds.width
    }
}

extension UIPanGestureRecognizer {
    var direction: ScrollDirection? {
        let velocity1 = velocity(in: view)
        let vertical = abs(velocity1.y) > abs(velocity1.x)
        
        switch (vertical, velocity1.x, velocity1.y) {
            case (true, _, let y) where y < 0: return .up
            case (true, _, let y) where y > 0: return .down
            case (false, let x, _) where x > 0: return .right
            case (false, let x, _) where x < 0: return .left
        default: return nil
        }
    }
}

extension CGSize {
    static var profileImage: CGSize {
        return CGSize(width: 500, height: 500)
    }
    
    static var headerImage: CGSize {
        return CGSize(width: 300, height: 300)
    }
}

extension CALayer {
    func addBorder(edge: UIRectEdge, color: UIColor, thickness: CGFloat) {
        let border = CALayer()
        switch edge {
        case .top:
            border.frame = CGRect(x: 0, y: 0, width: frame.width, height: thickness)
        case .bottom:
            border.frame = CGRect(x: 0, y: frame.height - thickness, width: frame.width, height: thickness)
        case .left:
            border.frame = CGRect(x: 0, y: 0, width: thickness, height: frame.height)
        case .right:
            border.frame = CGRect(x: frame.width - thickness, y: 0, width: thickness, height: frame.height)
        default:
            break
        }
        border.backgroundColor = color.cgColor;
        addSublayer(border)
    }
}

extension TimeInterval {
    static var duration02: TimeInterval {
        return 0.2
    }
}

extension UIEdgeInsets {
    static func insets(for inset: CGFloat) -> UIEdgeInsets {
        return UIEdgeInsets(top: inset, left: inset, bottom: inset, right: inset)
    }
}

extension UIApplication {
    var isKeyboardPresented: Bool {
        if let keyboardWindowClass = NSClassFromString("UIRemoteKeyboardWindow"),
            self.windows.contains(where: { $0.isKind(of: keyboardWindowClass) }) {
            return true
        } else {
            return false
        }
    }
}

extension Notification {
    var keyboardRect: CGRect? {
        guard let keyboardSize = userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {
            return nil
        }
        return keyboardSize.cgRectValue
    }
}

extension CGFloat {
    var margin8: CGFloat {
        return self + 8
    }
}
extension Int {
    var roundedWithAbbreviations: String {
        let number = Double(self)
        let thousand = number / 1000
        let million = number / 1000000
        if million >= 1.0 {
            return "\((round(million*10)/10).clean)M"
        }
        else if thousand >= 10.0 {
            return "\((round(thousand*10)/10).clean)K"
        }
        else {
            return "\(self)"
        }
    }
}

extension Double {
    var clean: String {
       return truncatingRemainder(dividingBy: 1) == 0 ? String(format: "%.0f", self) : String(self)
    }
}

extension UIScrollView {
    
    func scrollToTop() {
        setContentOffset(.init(x: 0, y: -contentInset.top), animated: true)
    }
}

extension Optional where Wrapped == UIRefreshControl {
    func end() {
        guard let this = self else {
            return
        }
        this.endRefreshing()
    }
}

extension Array where Element == UIImage? {
    mutating func appendIfNotExists(image: UIImage?) {
        if !contains(image) {
            append(image)
        }
    }
}

extension Dictionary where Key == Int, Value == UIImage? {
    mutating func appendIfNotExists(image: [Int:UIImage?]) {
    }
}

extension UIEdgeInsets {
    init(horizontal: CGFloat, vertical: CGFloat) {
        self.init(top: vertical, left: horizontal, bottom: vertical, right: horizontal)
    }
    
    init(side: CGFloat) {
        self.init(top: side, left: side, bottom: side, right: side)
    }
}

extension UIAlertController {
    func addActions(_ actions: UIAlertAction...) {
        for action in actions {
            addAction(action)
        }
    }
}

extension UITabBar {
    func pulse(index: Int) {
        guard let imageView = subviews[index + 1].subviews.first as? UIImageView else { return }
        imageView.bounce()
    }
}

extension CGSize {
    init(side: CGFloat) {
        self.init(width: side, height: side)
    }
}

extension Data {
    var toImage: UIImage? {
        return UIImage(data: self)
    }
}

extension UICollectionView {
    func reloadFirstSection() {
        reloadSections(IndexSet(arrayLiteral: 0))
    }
    
    func reloadFirstSection(completion: @escaping () -> ()) {
        UIView.animate(withDuration: 0.10) {
            self.reloadSections(IndexSet(arrayLiteral: 0))
        } completion: { (_) in
            completion()
        }
    }
    
    func reloadAsync() {
        DispatchQueue.main.async {
            self.reloadData()
        }
    }
    
    func reloadSection(index: Int) {
        reloadSections(IndexSet(arrayLiteral: index))
    }
}

extension Bool {
    var toInt: Int {
        return self ? 1 : 0
    }
}

extension Data {
    var toString: [String:AnyObject]? {
        guard let json = try? JSONSerialization.jsonObject(with: self, options: .allowFragments) as? [String:AnyObject] else {
            return nil
        }
        return json
    }
}
