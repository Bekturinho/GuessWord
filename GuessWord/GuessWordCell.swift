//
//  GuessWordCell.swift
//  4Photos1Word
//
//  Created by Ian Baikuchukov on 25/2/24.
//

import UIKit

class GuessWordCell: UICollectionViewCell {

    private lazy var letterLabel: UILabel = {
        let view = UILabel()
        view.font = .systemFont(ofSize: 30, weight: .black)
        view.textColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        backgroundColor = .black
        
        layer.cornerRadius = 12
        layer.borderWidth = 1
        layer.borderColor = UIColor.black.cgColor
        
        addSubview(letterLabel)
        NSLayoutConstraint.activate([
            letterLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            letterLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
        ])
    }
    
    func setLetter(_ letter: String) {
        letterLabel.isHidden = false
        letterLabel.text = String(letter).capitalized
       
    }
    func removeLetter() {
        letterLabel.isHidden = true
    }
   
    
}
