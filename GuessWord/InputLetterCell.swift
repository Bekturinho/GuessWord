//
//  InputLetterCell.swift
//  4Photos1Word
//
//  Created by Ian Baikuchukov on 25/2/24.
//

import UIKit

class InputLetterCell: UICollectionViewCell {
    
    private lazy var letterLabel: UILabel = {
        let view = UILabel()
        view.font = .systemFont(ofSize: 40, weight: .black)
        view.textColor = .black
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        backgroundColor = .white
        
        layer.cornerRadius = 12
        layer.borderWidth = 1
        layer.borderColor = UIColor.black.cgColor
        
        addSubview(letterLabel)
        NSLayoutConstraint.activate([
            letterLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            letterLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
        ])
    }
    
    func setLetter(_ letter: Character) {
        letterLabel.isHidden = false
        letterLabel.text = String(letter).capitalized
    }
    
    func removeLetter() {
        letterLabel.isHidden = true
    }
    
}

