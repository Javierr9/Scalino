//
//  ScalePage.swift
//  MVC-Template
//
//  Created by Mutiara Prasetyo on 09/06/21.
//

import UIKit

class ScalePage: UIView {
    
    @IBOutlet weak var titleMajorScalesLabel: UILabel!
    @IBOutlet weak var infoMajorScalesLabel: UILabel!
    @IBOutlet weak var guidanceMajorScalesLabel: UILabel!
    
    @IBOutlet weak var collectionViewScalePage: UICollectionView!
    @IBOutlet var contentView: UIView!
    
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
            bundle.loadNibNamed("CustomView", owner: self, options: nil)
            addSubview(contentView)
            contentView.frame = bounds
            contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            contentView.backgroundColor = .red
            initCollectionView()
        }

        private func initCollectionView() {
            let nib = UINib(nibName: "RoundCell", bundle: nil)
            collectionViewScalePage.register(nib, forCellWithReuseIdentifier: "RoundCell")
            collectionViewScalePage.dataSource = self
            collectionViewScalePage.delegate = self
        
        
    }
}

let collectionViewCell:[String] = ["C", "G", "D", "A", "E", "B", "F", "F#", "C#", "B♭", "D#", "A♭"]

extension ScalePage: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //jumlah cell di collection view
        return 12
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RoundCell", for: indexPath) as? CollectionViewScalePageCell else {
            fatalError("can't dequeue CustomCell")
        }
        cell.xibLabelScalePage.text = PianoModel.fullNotes[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("test")
    }
}
