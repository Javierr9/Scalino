//
//  ScalePage.swift
//  MVC-Template
//
//  Created by Mutiara Prasetyo on 09/06/21.
//

import UIKit

class ScalePage: UIView {
    
    let scaleLabels:[String] = ["C", "G", "D", "A", "E", "B", "F", "F#", "C#", "Bb", "Eb", "Ab"]
    let numberOfCells = 12
    let cellSize: CGFloat = 59
    var selectedScale = -1
    
    @IBOutlet weak var titleMajorScalesLabel: UILabel!
    @IBOutlet weak var infoMajorScalesLabel: UILabel!
    @IBOutlet weak var guidanceMajorScalesLabel: UILabel!
    @IBOutlet weak var collectionViewScalePage: UICollectionView!
    
    @IBOutlet weak var learnChordsButton: UIButton!
    @IBOutlet var contentView: UIView!
    
    public weak var navigationDelegate: NavigationDelegate?
    public weak var scalePageDelegate: ScalePageDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
        
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
        
    private func commonInit() {
        let bundle = Bundle(for: type(of: self))
        bundle.loadNibNamed("ScalePage", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        initCollectionView()
    }

    private func initCollectionView() {
        collectionViewScalePage.register(UINib(nibName: "RoundCell", bundle: nil), forCellWithReuseIdentifier: "RoundCell")
        collectionViewScalePage.dataSource = self
        collectionViewScalePage.delegate = self
    }
    
    @IBAction func learnChordsButtonTapped(_ sender: UIButton) {
        scalePageDelegate?.didTapLearnChord?(rootScale: scaleLabels[selectedScale])
    }
    public func hideScaleDescription() {
        infoMajorScalesLabel.isHidden = true
        guidanceMajorScalesLabel.isHidden = true
    }
    
    func changeIntoScalePrompt(rootNote: String) {
        guidanceMajorScalesLabel.isHidden = true
        learnChordsButton.isHidden = false
        let fullNotes = getNotesInScale(from: rootNote)
        let notes = fullNotes[0 ..< 8]
        infoMajorScalesLabel.textAlignment = .center
        infoMajorScalesLabel.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        infoMajorScalesLabel.text = "Try playing "
        for index in 0 ..< 8 { infoMajorScalesLabel.text! += index == 7 ? "\(notes[index])" : "\(notes[index]) - "}
    }
}



extension ScalePage: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //jumlah cell di collection view
        return numberOfCells
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RoundCell", for: indexPath) as? RoundCell else {
            return UICollectionViewCell()
        }
        cell.roundCellLabel.text = scaleLabels[indexPath.row]
        cell.roundCellLabel.textColor = Purple
        cell.roundCellLabel.font = UIFont.systemFont(ofSize: cell.roundCellLabel.font.pointSize, weight: .bold)
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? RoundCell else { return }
        cell.roundCellLabel.textColor = Purple
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? RoundCell else { return }
        cell.roundCellLabel.textColor = .white
        changeIntoScalePrompt(rootNote: scaleLabels[indexPath.row])
        selectedScale = indexPath.row
        scalePageDelegate?.didSelectScale?(rootScale: scaleLabels[indexPath.row])
    }
}

extension ScalePage: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: cellSize, height: cellSize)
    }
}
