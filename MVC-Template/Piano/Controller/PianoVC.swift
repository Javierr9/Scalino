//
//  PianoVC.swift
//  MVC-Template
//
//  Created by Mutiara Prasetyo on 09/06/21.
//

import UIKit

let middleViewTag = 0
let mainViewTag = 1
let scaleViewTag = 2
let letsLearnTag = 3
let chordLearnTag = 4

let CToECellWidth: CGFloat = 240
let FToBCellWidth: CGFloat = 320
let fullNotesCellWidth: CGFloat = 560
let numberOfOctaves = 2

class PianoVC: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: "FullNotesCell", bundle: .main), forCellWithReuseIdentifier: "FullNotesCell")
        collectionViewSetup()
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        setupMiddleView()
    }
    
//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        guard let point = touches.first?.location(in: collectionView),
//              let indexPath = collectionView.indexPathForItem(at: point),
//              let cell = collectionView.cellForItem(at: indexPath) as? FullNotesCell,
//              let subview = cell.hitTest(point, with: event)
//        else { return }
//        subview.backgroundColor = .red
//    }
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var middleView: UIView!
    @IBOutlet weak var noteDisplayToggle: UISwitch!
    @IBOutlet weak var numericNoteDisplayToggle: UISwitch!
    
    
    func setupMiddleView() {
        middleView.layer.cornerRadius = 16
        let mainMenuView = MainMenu()
//        mainMenuView.delegate = self
        mainMenuView.tag = mainViewTag
        addMiddleView(with: mainMenuView, tag: mainViewTag)
        
    }
    func removeMiddleView(tag: Int) {
        guard let viewToRemove = middleView.viewWithTag(tag) else { return }
        viewToRemove.removeFromSuperview()
    }
    func addMiddleView(with subview: UIView, tag: Int) {
        subview.tag = tag
        subview.translatesAutoresizingMaskIntoConstraints = false
        middleView.addSubview(subview)
        subview.topAnchor.constraint(equalTo: middleView.topAnchor).isActive = true
        subview.leadingAnchor.constraint(equalTo: middleView.leadingAnchor).isActive = true
        subview.trailingAnchor.constraint(equalTo: middleView.trailingAnchor).isActive = true
        subview.bottomAnchor.constraint(equalTo: middleView.bottomAnchor).isActive = true
    }
    
    
    func collectionViewSetup() {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        layout.scrollDirection = .horizontal
        collectionView.collectionViewLayout = layout
    }
    @IBAction func sliderValueChanged(_ sender: UISlider) {
        collectionView.setContentOffset(CGPoint(x: Int(sender.value), y: 0), animated: false)
    }
    @IBAction func toggleNoteDisplay(_ sender: UISwitch) {
        collectionView.reloadData()
    }
}

extension PianoVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return numberOfOctaves
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let fullNotesCell = collectionView.dequeueReusableCell(withReuseIdentifier: "FullNotesCell", for: indexPath) as? FullNotesCell,
              var rootNoteIndex = PianoModel.fullNotes.firstIndex(of: "C")
        else { return UICollectionViewCell() }
        
        for index in 0 ..< 17 {
            fullNotesCell.noteLabels[index].isHidden = !noteDisplayToggle.isOn
        }
        for index in 0 ..< 8 {
            fullNotesCell.numericNoteLabels[rootNoteIndex].isHidden = !numericNoteDisplayToggle.isOn
            fullNotesCell.numericNoteLabels[rootNoteIndex].text = "\(index)"
            rootNoteIndex += PianoModel.intervals[index]
            if rootNoteIndex > 11 { rootNoteIndex -= 12 }
        }
        return fullNotesCell
    }
}

extension PianoVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: fullNotesCellWidth, height: collectionView.frame.height)
    }
}

extension PianoVC: NavigationDelegate {
    func navigateToScale() {
        removeMiddleView(tag: mainViewTag)
        let scaleView = ScalePage()
//        scaleView.delegate = self
        addMiddleView(with: scaleView, tag: scaleViewTag)
    }
    func navigateToMain() {
        removeMiddleView(tag: scaleViewTag)
        let mainView = MainMenu()
//        mainView.delegate = self
        addMiddleView(with: mainView, tag: mainViewTag)
    }
}

