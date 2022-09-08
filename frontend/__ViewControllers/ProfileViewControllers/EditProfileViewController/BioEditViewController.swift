//
//  BioEditViewController.swift
//  searchBar
//
//  Created by Pietro Putelli on 06/08/2020.
//  Copyright © 2020 Pietro Putelli. All rights reserved.
//

import UIKit

class BioEditViewController: NavigationBarViewController {
    
    // MARK: - Models
    
    lazy var textView: UITextView = {
        let tv = UITextView()
        tv.backgroundColor = .maire
        tv.tintColor = .perla
        tv.textContainerInset = .init(horizontal: 10, vertical: 10)
        tv.roundCorner(radius: 8)
        tv.textContainer.lineBreakMode = .byTruncatingTail
        tv.textColor = .white(alpha: 0.8)
        tv.font = Fonts.Main.withSize(16)
        tv.delegate = self
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()
    
    lazy var charactersCountLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white(alpha: 0.6)
        label.font = Fonts.Main.withSize(12)
        label.text = "\(maxCharactersCount)"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var clearButton: UIButton = {
        let button = UIButton()
        button.setTitle("CLEAR", for: .normal)
        button.titleLabel?.font = Fonts.Main.withSize(14)
        button.setTitleColor(.white(alpha: 0.6), for: .normal)
        button.addTarget(self, action: #selector(clearButton(_:)), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: - Proprieties
    
    private var textViewHeight: CGFloat {
        return view.frame.height * (1 / 4)
    }
    
    private let maxLinesCount: Int = 8
    private let maxCharactersCount: Int = 160
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupSubviews()
        addConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        guard let bioText = TemporaryUserSettings.bio else {
            textView.text = User.shared.bio
            return
        }
        textView.text = bioText
    }
    
    override func viewDidAppear(_ animated: Bool) {
        textView.becomeFirstResponder()
    }
    
    private func setupSubviews() {
        navigationBar.delegate = self
        navigationBar.setup(.settings)
        navigationBar.title = "Bio".uppercased()
        isEdgeGesturesEnabled = false
        
        view.addSubviews(textView,charactersCountLabel,clearButton)
    }
    
    private func addConstraints() {
        NSLayoutConstraint.activate([
            textView.topAnchor.constraint(equalTo: navigationBar.bottomAnchor, constant: 16),
            textView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            textView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            textView.heightAnchor.constraint(equalToConstant: textViewHeight),
            
            charactersCountLabel.trailingAnchor.constraint(equalTo: textView.trailingAnchor, constant: -8),
            charactersCountLabel.topAnchor.constraint(equalTo: textView.bottomAnchor, constant: 8),
            
            clearButton.leadingAnchor.constraint(equalTo: textView.leadingAnchor, constant: 8),
            clearButton.centerYAnchor.constraint(equalTo: charactersCountLabel.centerYAnchor),
            clearButton.heightAnchor.constraint(equalToConstant: 20)
        ])
    }
    
    @objc private func clearButton(_ sender: UIButton) {
        sender.pulse()
        textView.text = nil
        charactersCountLabel.text = "\(maxCharactersCount)"
    }
}

extension BioEditViewController: BounceViewDelegate {
    
    func touchesEnded(_ bounceView: BounceView) {
        if bounceView.tag == 0 {
            let text = textView.text ?? nil
            TemporaryUserSettings.bio = text
        }
        navigationController?.popViewController(animated: true)
    }
}

extension BioEditViewController: UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        charactersCountLabel.text = "\(maxCharactersCount - textView.text.count)"
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        guard let textViewString = textView.text, let range = Range(range, in: textViewString) else {
            return false
        }
        
        let newString = textViewString.replacingCharacters(in: range, with: text)
        
        let existingLines = textView.text.components(separatedBy: CharacterSet.newlines)
        let newLines = text.components(separatedBy: CharacterSet.newlines)
        let linesAfterChange = existingLines.count + newLines.count - 1
        let linesCheck = linesAfterChange < maxLinesCount
        
        let characterCountCheck = newString.utf16.count <= maxCharactersCount
        return linesCheck && characterCountCheck
    }
}
