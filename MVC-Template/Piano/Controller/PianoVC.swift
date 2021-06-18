
//
//  ViewController.swift
//  MC2
//
//  Created by Nico Christian on 28/05/21.
//

import UIKit
import AVFoundation

let middleViewTag = 0
let mainViewTag = 1
let scaleViewTag = 2
let letsLearnTag = 3
let chordLearnTag = 4

let CToECellWidth: CGFloat = 240
let FToBCellWidth: CGFloat = 320
let fullNotesCellWidth: CGFloat = 560
let numberOfOctaves = 3

class PianoVC: UIViewController {

    var audioPlayer: AVAudioPlayer?
    var soundFilename: [String] = []
    var previousView: UIView?
    var rootNote = "C"
    var score = 0
    var correctAnswer = getScaleAnswer(from: "C")
    var isLearningScale = false
    let center = UNUserNotificationCenter.current()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: "FullNotesCell", bundle: .main), forCellWithReuseIdentifier: "FullNotesCell")
        collectionView.register(UINib(nibName: "C", bundle: .main), forCellWithReuseIdentifier: "CCell")
        collectionViewSetup()
        initializeSoundFilename()
        //get notification
        registerLocal()
        scheduleLocal()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        setupMiddleView()
    }
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var middleView: UIView!
    @IBOutlet weak var noteDisplayToggle: UISwitch!
    @IBOutlet weak var numericNoteDisplayToggle: UISwitch!
    
    
    func setupMiddleView() {
        middleView.layer.cornerRadius = 16
        let mainMenuView = MainMenu()
        mainMenuView.delegate = self
        mainMenuView.tag = mainViewTag
        previousView = mainMenuView
        addMiddleView(with: mainMenuView, tag: mainViewTag)
        
    }
    func removeMiddleView(tag: Int) {
        guard let viewToRemove = middleView.viewWithTag(tag) else { return }
        previousView = viewToRemove
        viewToRemove.removeFromSuperview()
    }
    func addMiddleView(with subview: UIView, tag: Int) {
        subview.tag = tag
        subview.translatesAutoresizingMaskIntoConstraints = false
        subview.backgroundColor = .white
        subview.layer.cornerRadius = 16
        middleView.addSubview(subview)
        
        NSLayoutConstraint.activate([
            subview.topAnchor.constraint(equalTo: middleView.topAnchor),
            subview.leadingAnchor.constraint(equalTo: middleView.leadingAnchor),
            subview.trailingAnchor.constraint(equalTo: middleView.trailingAnchor),
            subview.bottomAnchor.constraint(equalTo: middleView.bottomAnchor)
        ])
    }
    
    
    func collectionViewSetup() {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        layout.scrollDirection = .horizontal
        collectionView.collectionViewLayout = layout
        collectionView.reloadData()
    }
    @IBAction func sliderValueChanged(_ sender: UISlider) {
        collectionView.setContentOffset(CGPoint(x: Int(sender.value), y: 0), animated: false)
    }
    @IBAction func toggleNoteDisplay(_ sender: UISwitch) {
        collectionView.reloadData()
    }
    @IBAction func returnToPreviousView(_ sender: UIButton) {
        addMiddleView(with: previousView ?? MainMenu(), tag: 1)
        isLearningScale = false
    }
    
    func initializeSoundFilename() {
        for index in 0 ..< 24 {
            soundFilename.append("\(PianoModel.fullNotes[index]) - \(index > 11 ? "2" : "1")")
        }
        soundFilename.append("C - 3")
    }
    
    func playSound(key: Int) {
        guard let pathToSound = Bundle.main.path(forResource: soundFilename[key], ofType: "wav") else { return }
        let url = URL(fileURLWithPath: pathToSound)
        
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.play()
        } catch {
            print("error playing sound")
        }
    }
    
    func generateGesture(notePressed: Int, noteLabel: UILabel, noteView: UIView) -> NoteLongPressGesture {
        let customGesture = NoteLongPressGesture()
        customGesture.minimumPressDuration = 0.001
        customGesture.notePressed = notePressed
        customGesture.noteLabel = noteLabel
        customGesture.noteView = noteView
        customGesture.addTarget(self, action: #selector(pianoNotePressed(_:)))
        return customGesture
    }
    
    //register notification
    func registerLocal() {
        center.removeAllPendingNotificationRequests()
        center.requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
        }
    }
    
    //schedule notification
    func scheduleLocal() {
        let content = UNMutableNotificationContent()
        content.title = "title"
        content.body = "description"
        content.categoryIdentifier = "alarm"
        content.sound = .default
        
        var dateComponents = DateComponents()
        dateComponents.hour = 11
        dateComponents.minute = 16
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        let request = UNNotificationRequest (identifier: UUID().uuidString, content: content, trigger: trigger)
        center.add(request)
    }
}

extension PianoVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return numberOfOctaves
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.row < 2 {
            guard let fullNotesCell = collectionView.dequeueReusableCell(withReuseIdentifier: "FullNotesCell", for: indexPath) as? FullNotesCell,
                  var rootNoteIndex = PianoModel.fullNotes.firstIndex(of: rootNote)
            else { return UICollectionViewCell() }
            
            for index in 0 ..< 17 {
                fullNotesCell.noteLabels[index].isHidden = !noteDisplayToggle.isOn
            }
            for index in 0 ..< 12 {
                fullNotesCell.noteViews[index].addGestureRecognizer(generateGesture(notePressed: indexPath.row == 0 ? index : index + 12, noteLabel: fullNotesCell.noteLabels[index], noteView: fullNotesCell.noteViews[index]))
                fullNotesCell.numericNoteLabels[index].isHidden = true
            }
            for index in 0 ..< 8 {
                fullNotesCell.numericNoteLabels[rootNoteIndex].isHidden = !numericNoteDisplayToggle.isOn
                fullNotesCell.numericNoteLabels[rootNoteIndex].text = "\(index)"
                rootNoteIndex += PianoModel.intervals[index]
                if rootNoteIndex > 11 { rootNoteIndex -= 12 }
            }
            return fullNotesCell
        } else {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CCell", for: indexPath) as? C else { return UICollectionViewCell() }
            cell.noteLabel.isHidden = !noteDisplayToggle.isOn
            cell.numericNoteLabel.isHidden = !numericNoteDisplayToggle.isOn
            cell.noteView.addGestureRecognizer(generateGesture(notePressed: 24, noteLabel: cell.noteLabel, noteView: cell.noteView))
            return cell
        }
        
    }
    
    @objc func pianoNotePressed(_ sender: NoteLongPressGesture) {
        guard let notePressed = sender.notePressed,
              let noteView = sender.noteView,
              let noteLabel = sender.noteLabel
        else { return }
        
        if sender.state == .began {
            playSound(key: notePressed)
            noteLabel.textColor = .white
            noteView.backgroundColor = Purple
            
        }
        else if sender.state == .ended {
            sender.noteView?.backgroundColor = PianoModel.blackNotesTag.firstIndex(of: notePressed) != nil ? .black : .white
            noteLabel.textColor = PianoModel.blackNotesTag.firstIndex(of: notePressed) != nil ? .white : .black
            if isLearningScale {
                if notePressed == correctAnswer[score] { score += 1 }
                if score == 8 {
                    score = 0
                    let alert = UIAlertController(title: "Hooray!", message: "Good job, you have played the C Major Scale", preferredStyle: .alert)
                    let ok = UIAlertAction(title: "Let's learn some more", style: .default, handler: nil)
                    alert.addAction(ok)
                    self.present(alert, animated: true, completion: nil)
                }
            }
        }
    }
}

extension PianoVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return indexPath.row < 2 ? CGSize(width: fullNotesCellWidth, height: collectionView.frame.height) : CGSize(width: 80, height: collectionView.frame.height)
    }
}

extension PianoVC: NavigationDelegate, ScalePageDelegate {
    func navigateToMain() {
        removeMiddleView(tag: scaleViewTag)
        let mainView = MainMenu()
        mainView.delegate = self
        addMiddleView(with: mainView, tag: mainViewTag)
    }
    
    func navigateToLearnScale() {
        removeMiddleView(tag: mainViewTag)
        let scaleView = ScalePage()
        scaleView.navigationDelegate = self
        scaleView.scalePageDelegate = self
        isLearningScale = true
        addMiddleView(with: scaleView, tag: scaleViewTag)
    }
    
    func didSelectScale(rootScale: String) {
        rootNote = rootScale
        collectionView.reloadData()
    }
}
