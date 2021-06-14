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
            let nib = UINib(nibName: "CustomCell", bundle: nil)
            collectionViewScalePage.register(nib, forCellWithReuseIdentifier: "CustomCell")
            collectionViewScalePage.dataSource = self
            collectionViewScalePage.delegate = self
        
        
    }
}

extension ScalePage: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //jumlah cell di collection view
        return 12
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CustomCell", for: indexPath) as? CollectionViewScalePageCell else {
            fatalError("can't dequeue CustomCell")
        }
        cell.xibLabelScalePage.text = "button scale"
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("test")
    }
}
