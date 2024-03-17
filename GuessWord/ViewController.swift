//
//  ViewController.swift
//  GuessWord
//
//  Created by fortune cookie on 3/9/24.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDelegate {
    
    private var photosCollectionView: UICollectionView!
    
    private var wordCollectionView: UICollectionView!
    
    private var lettersCollectionView: UICollectionView!
    
    private var gameServise = GameService()
    
    private lazy var currentUserGuess = Array(repeating: " ", count: gameServise.wordToGuess.count)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setUpPhotosCollectionView()
        setUpWordsCollectionView()
        setUpLettersCollectionView()
        setUpSubViews()
    }
    
    private func setUpPhotosCollectionView(){
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 150, height: 150)
        layout.minimumInteritemSpacing = 20
        layout.minimumLineSpacing = 10
        layout.sectionInset = UIEdgeInsets(top: 10, left: 16, bottom: 10, right: 16)
        
        photosCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout
        )
        photosCollectionView.register(PhotoCell.self, forCellWithReuseIdentifier: PhotoCell.identifier)
        photosCollectionView.dataSource = self
    }
    
    private func setUpWordsCollectionView(){
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 38, height: 50)
        layout.minimumInteritemSpacing = 0
        
        wordCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        wordCollectionView.backgroundColor = .clear
        wordCollectionView.register(GuessWordCell.self, forCellWithReuseIdentifier: GuessWordCell.identifier)
        wordCollectionView.dataSource = self
        wordCollectionView.delegate = self
    }
    
    private func setUpLettersCollectionView(){
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 50, height: 50)
        lettersCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        lettersCollectionView.backgroundColor = .clear
        lettersCollectionView.register(InputLetterCell.self, forCellWithReuseIdentifier: InputLetterCell.identifier)
        lettersCollectionView.dataSource = self
        lettersCollectionView.delegate = self
    }

    private func setUpSubViews(){
        [photosCollectionView,wordCollectionView,lettersCollectionView].forEach({collectionView in
            guard let collectionView else {return}
            view.addSubview(collectionView)
            collectionView.translatesAutoresizingMaskIntoConstraints = false
        })
        
        NSLayoutConstraint.activate([
            photosCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50),
            photosCollectionView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20),
            photosCollectionView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20),
            photosCollectionView.heightAnchor.constraint(equalToConstant: 330),
            
            wordCollectionView.topAnchor.constraint(equalTo: photosCollectionView.bottomAnchor, constant: 40),
            wordCollectionView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 40),
            wordCollectionView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -40),
            wordCollectionView.heightAnchor.constraint(equalToConstant: 50),
            
            lettersCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            lettersCollectionView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16),
            lettersCollectionView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16),
            lettersCollectionView.heightAnchor.constraint(equalToConstant: 120)
        ])
    }

    
    
}

extension ViewController: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView{
        case photosCollectionView: numberOfItemsForPhotosCollectionView()
            
        case wordCollectionView: numberOfItemsForWordCollectionView()
            
        case lettersCollectionView: numberOfItemsForLettersCollectionView()
            
        default:
            0
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch collectionView{
        case photosCollectionView:photoCell(at: indexPath) ?? UICollectionViewCell()
            
        case wordCollectionView:wordCell(at: indexPath) ?? UICollectionViewCell()
            
        case lettersCollectionView: inputLetterCell(at: indexPath) ?? UICollectionViewCell()
            
        default:
            UICollectionViewCell()
        }
    }
    func photoCell(at indexPath: IndexPath) -> PhotoCell? {
        guard let cell = photosCollectionView.dequeueReusableCell(withReuseIdentifier: PhotoCell.identifier, for: indexPath) as? PhotoCell else { return nil }
        cell.setImage(named: gameServise.imagesArray[indexPath.item])
        
        return cell
    }
    func wordCell(at indexPath: IndexPath) -> GuessWordCell? {
        guard let cell = wordCollectionView.dequeueReusableCell(withReuseIdentifier: GuessWordCell.identifier, for: indexPath) as? GuessWordCell else {
            return nil
        }
        
        let letter = currentUserGuess[indexPath.item]
        if letter != " " {
            cell.setLetter(letter)
        } else {
            cell.removeLetter()
        }
        
        return cell
    }
    
    func inputLetterCell(at indexPath: IndexPath) -> InputLetterCell? {
        guard let cell = lettersCollectionView.dequeueReusableCell(withReuseIdentifier: InputLetterCell.identifier, for: indexPath) as? InputLetterCell else {
            return nil
        }
        
        let letter = gameServise.letters[indexPath.item]
        if letter != Character(" ") {
            cell.setLetter(letter)
        } else {
            cell.removeLetter()
        }
        
        return cell
    }
    func numberOfItemsForPhotosCollectionView() -> Int {
        gameServise.imagesArray.count
    }
    func numberOfItemsForWordCollectionView() -> Int {
        currentUserGuess.count
    }
    func numberOfItemsForLettersCollectionView() -> Int {
        gameServise.letters.count
    }
    
}

extension ViewController: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch collectionView {
        case lettersCollectionView:
            setSelectedLetterToWordCollectionView(indexPath: indexPath)
            removeSelectedLetterFromLettersCollectionView(indexPath: indexPath)
            checkIfIsCorrect()
            
        case wordCollectionView:
            setBackSelectedLetterToLettersCollectionView(indexPath: indexPath)
            removeSelectedLetterFromWordCollectionView(indexPath: indexPath)
            
        default:
            break
        }
    }
    
    func setSelectedLetterToWordCollectionView(indexPath: IndexPath) {
        guard let nextIndexWithoutLetter = currentUserGuess.firstIndex(where: { $0 == " " } ) else {
            return
        }
        
        currentUserGuess[nextIndexWithoutLetter] = String(gameServise.letters[indexPath.item])
        wordCollectionView.reloadData()
    }
    
    func removeSelectedLetterFromLettersCollectionView(indexPath: IndexPath) {
        gameServise.letters[indexPath.item] = Character(" ")
        lettersCollectionView.reloadData()
    }
    
    func setBackSelectedLetterToLettersCollectionView(indexPath: IndexPath) {
        guard let indexWithoutLetter = gameServise.letters.firstIndex(where: { $0 == " " }) else { return }
        
            gameServise.letters[indexWithoutLetter] = Character(currentUserGuess[indexPath.item])
        lettersCollectionView.reloadData()
    }
    
    func removeSelectedLetterFromWordCollectionView(indexPath: IndexPath) {
        currentUserGuess[indexPath.item] = " "
        wordCollectionView.reloadData()
    }
    
    func checkIfIsCorrect() {
     
        winOrLose(){result in
            
        }
       
    }
    
    func winOrLose(completion: @escaping (Bool) -> Void){
        let wordToGuessAsArray = gameServise.wordToGuess.map { String($0).lowercased() }
        let isAllFilled = currentUserGuess.allSatisfy { $0 != " " }
        if wordToGuessAsArray == currentUserGuess {
            let winAlert = UIAlertController(title: "You Won", message: "Congratulations !", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Ok", style: .cancel){_ in
                self.getBackToOrigin()
              
            }
            
            winAlert.addAction(okAction)
            self.present(winAlert, animated: true)
            completion(true)

        }
        else if isAllFilled && wordToGuessAsArray != currentUserGuess {
           print("lose")
            let loseAlert = UIAlertController(title: "You Lose", message: "You want to try again ?", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "Yes", style: .default){_ in 
                self.getBackToOrigin()
            }
            let tryAgainAction = UIAlertAction(title: "Try Again", style: .default){_ in
                self.getBackToOrigin()
            }
            loseAlert.addAction(cancelAction)
            loseAlert.addAction(tryAgainAction)
            self.present(loseAlert, animated: true)
            completion(false)
       }
           
       
    
    }
 
    func getBackToOrigin(){
        currentUserGuess = self.currentUserGuess.map({_ in " "})
        wordCollectionView.reloadData()
        gameServise.letters =  self.gameServise.rezerve
        lettersCollectionView.reloadData()
    }
 
   

}
