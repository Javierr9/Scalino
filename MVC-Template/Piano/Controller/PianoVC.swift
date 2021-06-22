
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
let chordViewTag = 4

let CToECellWidth: CGFloat = 240
let FToBCellWidth: CGFloat = 320
let fullNotesCellWidth: CGFloat = 1200
let numberOfOctaves = 1

class PianoVC: UIViewController {

    var audioPlayer: AVAudioPlayer?
    var soundFilename: [String] = []
    var previousView: UIView?
    var rootNote = "C"
    var score = 0
    var correctAnswer: [Int] = []
    var isLearningScale = false
    var isShowingChordIndicator = false
    let center = UNUserNotificationCenter.current()
    var viewHierarchy: [UIView] = []
    var c3Numeric = "1"
    var chordNumber = [1, 3, 5]
    var isTestScale = false
    var isTestChord = false
    var currentExercise = 1
    var chordsPlayed: [Int] = []
    var nthChord = 1
    let chordExercise: [Int] = [0, 2, 4, 6]
    override var preferredScreenEdgesDeferringSystemGestures: UIRectEdge {
        return UIRectEdge.bottom
    }
    override var prefersHomeIndicatorAutoHidden: Bool {
        return false
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: "FullNotesCell", bundle: .main), forCellWithReuseIdentifier: "FullNotesCell")
        collectionView.register(UINib(nibName: "C", bundle: .main), forCellWithReuseIdentifier: "CCell")
        collectionView.register(UINib(nibName: "FullOctaveCell", bundle: .main), forCellWithReuseIdentifier: "FullOctaveCell")
        collectionViewSetup()
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
    @IBOutlet weak var mainBackButton: backButton!
    
    
    func setupMiddleView() {
        middleView.layer.cornerRadius = 16
        let mainMenuView = MainMenu()
        mainMenuView.delegate = self
        mainMenuView.tag = mainViewTag
        appendView(view: mainMenuView)
    }
    
    func appendView(view: UIView) {
        mainBackButton.isHidden = false
        viewHierarchy.append(view)
        reloadMiddleView()
    }
    
    func removeView() {
        viewHierarchy.removeLast()
        reloadMiddleView()
    }
    
    func reloadMiddleView() {
        if viewHierarchy.count <= 1 {
            mainBackButton.isHidden = true
            isLearningScale = false
            isShowingChordIndicator = false
            rootNote = "C"
            collectionView.reloadData()
        }
        if let subview = viewHierarchy.last {
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
        resetQuestions()
        removeView()
    }
    
    func playSound(key: Int) {
        if let url = Bundle.main.url(forResource: "\(key+1)", withExtension: "wav") {
            let player = AVAudioPlayerPool().playerWithURL(url: url)
            player?.play()
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
        content.title = "Scalino"
        content.body = "Hey! Don't forget to learn today!"
        content.categoryIdentifier = "alarm"
        content.sound = .default
        
        var dateComponents = DateComponents()
        dateComponents.calendar = Calendar.current
        dateComponents.hour = 19
        dateComponents.minute = 0
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        let request = UNNotificationRequest (identifier: UUID().uuidString, content: content, trigger: trigger)
        center.add(request)
    }
    
    func presentAlert(message: String) {
        let alert = UIAlertController(title: "Hooray!", message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "Continue", style: .default, handler: nil)
        alert.addAction(ok)
        self.present(alert, animated: true, completion: nil)
    }
    
    func checkChord() {
        let scale = getScaleAnswer(from: rootNote)
        print(scale)
        var correctChord: [Int] = []
        for i in 0 ..< 3 {
            correctChord.append(scale[chordNumber[i] - 1])
        }
        print("correct chord:  \(correctChord)")
        print("chords playes: \(chordsPlayed)")
        if isTestChord {
            if correctChord.elementsEqual(chordsPlayed) {
                if currentExercise == 4 {
                    currentExercise = 0
                    let message = "Good Job!"
                    resetQuestions()
                    presentAlert(message: message)
        
                    return
                }
                chordNumber = [1,3,5]
                let chordNames = getChordNames(from: rootNote)
                
                currentExercise += 1
                nthChord = chordExercise[currentExercise - 1]
                for i in 0 ..< 3 { chordNumber[i] += nthChord }
                
                guard let chordPage = viewHierarchy.last as? ScalePage else { return }
                chordPage.infoMajorScalesLabel.text = "Play \(chordNames[chordExercise[currentExercise - 1]])"
                chordPage.guidanceMajorScalesLabel.text = "\(currentExercise)/\(chordExercise.count)"
                collectionView.reloadData()
               
            }
        } else {
            guard let chordPage = viewHierarchy.last as? ChordPage else { return }
            if correctChord.elementsEqual(chordsPlayed) {
//                print("BETUL CONG")
                chordPage.Buttons[nthChord].backgroundColor = green
                chordPage.Buttons[nthChord].layer.borderColor = green.cgColor
                
            } else {
//                print("SALAH CONG")
                chordPage.Buttons[nthChord].backgroundColor = red
                chordPage.Buttons[nthChord].layer.borderColor = red.cgColor
            }
            chordPage.Buttons[nthChord].setTitleColor(.white, for: .normal)
        }
        chordsPlayed.removeAll()
    }
}

extension PianoVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return numberOfOctaves
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FullOctaveCell", for: indexPath) as? FullOctaveCell,
              var rootNoteIndex = PianoModel.fullNotes.firstIndex(of: rootNote)
        else { return UICollectionViewCell() }
        for noteLabel in cell.noteLabels { noteLabel.isHidden = !noteDisplayToggle.isOn }
        for numericLabel in cell.numericNoteLabels { numericLabel.isHidden = true }
        for index in 0 ..< 25 {
            cell.noteViews[index].addGestureRecognizer(generateGesture(notePressed: index, noteLabel: cell.noteLabels[index], noteView: cell.noteViews[index]))
            cell.noteViews[index].backgroundColor = PianoModel.blackNotesTag.firstIndex(of: index) != nil ? .black : .white
        }
        var interval = PianoModel.intervals
        interval.append(contentsOf: [2,2,1,2,2,2,1,2,2,1,2,2,2,1])
        for index in 0 ..< 15 {
            cell.numericNoteLabels[rootNoteIndex].isHidden = !numericNoteDisplayToggle.isOn
            cell.numericNoteLabels[rootNoteIndex].text = index <= 14 ? (index > 7 ? "\(index - 7)" : "\(index)") : "\(index - 14)"
            if isShowingChordIndicator {
                cell.noteViews[rootNoteIndex].backgroundColor = chordNumber.firstIndex(of: index) != nil ? lightPurple : (PianoModel.blackNotesTag.firstIndex(of: rootNoteIndex) != nil ? .black : .white)
                cell.numericNoteLabels[rootNoteIndex].textColor = chordNumber.firstIndex(of: index) != nil ? Purple : lightPurple
            }
            rootNoteIndex += interval[index]
            if rootNoteIndex > 24 { rootNoteIndex -= 24 }
        }
        return cell
        
    }
    
    @objc func pianoNotePressed(_ sender: NoteLongPressGesture) {
        guard let notePressed = sender.notePressed,
              let noteView = sender.noteView,
              let noteLabel = sender.noteLabel
        else { return }
        if sender.state == .began {
            playSound(key: notePressed)
            chordsPlayed.append(notePressed)
            noteLabel.textColor = .white
            noteView.backgroundColor = Purple
            if chordsPlayed.count == 3 { checkChord() }
        }
        else if sender.state == .ended {
            guard let noteToRemove = chordsPlayed.firstIndex(of: notePressed) else { return }
            chordsPlayed.remove(at: noteToRemove)

            noteView.backgroundColor = PianoModel.blackNotesTag.firstIndex(of: notePressed) != nil ? .black : .white
            noteLabel.textColor = PianoModel.blackNotesTag.firstIndex(of: notePressed) != nil ? .white : .black
            
            if isLearningScale {
                if notePressed == correctAnswer[score] { score += 1 }
                if score == 8 {
                    score = 0
                    let alert = UIAlertController(title: "Hooray!", message: "Good job, you have played the \(rootNote) Major Scale", preferredStyle: .alert)
                    let ok = UIAlertAction(title: "Let's learn other scale", style: .default, handler: nil)
                    alert.addAction(ok)
                    self.present(alert, animated: true, completion: nil)
                }
            } else if isTestScale {
                guard let testScaleView = viewHierarchy.last as? ScalePage else { return }
                var message = ""
                
                if currentExercise >= 1  && currentExercise <= 2{
                    if notePressed == correctAnswer[score] {
                        score += 1
                    }
                    if score == 8 {
                        score = 0
                        message = currentExercise == 1 ? "Good job, you have played the \(rootNote) Major Scale. Now try playing the scale in reverse." : "Good job, you have played the \(rootNote) Major scale in reverse. Now try to play the third note from \(rootNote) Major Scale"
                        
                        if currentExercise == 1 {
                            testScaleView.infoMajorScalesLabel.text! += " in reverse!"
                            correctAnswer.reverse()
                        } else if currentExercise == 2 {
                            testScaleView.infoMajorScalesLabel.text = "Try pressing the third note from the \(rootNote) major scale"
                        }
                        presentAlert(message: message)
                        currentExercise += 1
                    }
                } else if currentExercise == 3 {
                    correctAnswer.reverse()
                    if notePressed == correctAnswer[2] {
                        message = "Good job, the third note in \(rootNote) major scale is \(PianoModel.fullNotes[correctAnswer[2]])"
                        presentAlert(message: message)
                        currentExercise += 1
                        testScaleView.infoMajorScalesLabel.text = "Try pressing the sixth note from the \(rootNote) major scale"
                    }
                } else if currentExercise == 4 {
                    if notePressed == correctAnswer[5] {
                        message = "Great job, you finished the exercise for \(rootNote) Major Scale. Let's try exercising with other scales!"
                        testScaleView.infoMajorScalesLabel.text = "Pick a scale"
                        presentAlert(message: message)
                        testScaleView.guidanceMajorScalesLabel.isHidden = true
                        currentExercise += 1
                    }
                }
                testScaleView.guidanceMajorScalesLabel.text = "\(currentExercise)/4"
            }
            collectionView.reloadData()
        }
    }
}

extension PianoVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: fullNotesCellWidth, height: collectionView.frame.height)
    }
}

extension PianoVC: NavigationDelegate, ScalePageDelegate, ChordPageDelegate {
   
    func navigateToTestScale() {
        let testScaleView = ScalePage()
        testScaleView.scalePageDelegate = self
        testScaleView.tag = scaleViewTag
        testScaleView.initiateTestView(choice: "SCALE")
        testScaleView.isTestScale = true
        testScaleView.infoMajorScalesLabel.text = "Pick a scale!"
        testScaleView.infoMajorScalesLabel.textAlignment = .center
        testScaleView.infoMajorScalesLabel.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        testScaleView.guidanceMajorScalesLabel.text = "\(currentExercise)/4"
        appendView(view: testScaleView)
    }
    
    func navigateToTestChord() {
        let testChordView = ScalePage()
        testChordView.scalePageDelegate = self
        testChordView.tag = scaleViewTag
        testChordView.initiateTestView(choice: "CHORD")
        testChordView.isTestChord = true
        testChordView.infoMajorScalesLabel.text = "Pick a scale!"
        testChordView.infoMajorScalesLabel.textAlignment = .center
        testChordView.infoMajorScalesLabel.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        appendView(view: testChordView)
    }
    
    func navigateToLearnScale() {
        let scaleView = ScalePage()
        scaleView.navigationDelegate = self
        scaleView.scalePageDelegate = self
        scaleView.tag = scaleViewTag
        scaleView.initiateLearnView()
        appendView(view: scaleView)
    }
    func didSelectScale(rootScale: String, test: String) {
        rootNote = rootScale
        if test == "Scale" {
            currentExercise = 1
            score = 0
            isLearningScale = false
            isTestScale = true
            correctAnswer = getScaleAnswer(from: rootNote)
            guard let testScaleView = viewHierarchy.last as? ScalePage else { return }
            testScaleView.initiateScalePrompt(rootNote: rootScale)
            testScaleView.guidanceMajorScalesLabel.isHidden = false
            testScaleView.guidanceMajorScalesLabel.textAlignment = .center
            testScaleView.guidanceMajorScalesLabel.text = "\(currentExercise)/4"
        } else if test == "Chord" {
            let chordNames = getChordNames(from: rootNote)
            currentExercise = 1
            nthChord = chordExercise[currentExercise - 1]
            isLearningScale = false
            isTestChord = true
            guard let testScaleView = viewHierarchy.last as? ScalePage else { return }
            testScaleView.infoMajorScalesLabel.text = "Play \(chordNames[chordExercise[currentExercise - 1]])"
            testScaleView.infoMajorScalesLabel.textAlignment = .center
            testScaleView.infoMajorScalesLabel.font = UIFont.systemFont(ofSize: 16, weight: .bold)
            testScaleView.guidanceMajorScalesLabel.isHidden = false
            testScaleView.guidanceMajorScalesLabel.textAlignment = .center
            testScaleView.guidanceMajorScalesLabel.text = "\(currentExercise)/4"
        } else if test == "" {
            isLearningScale = true
            correctAnswer = getScaleAnswer(from: rootNote)
        }
        collectionView.reloadData()
    }
    
    func didTapLearnChord(rootScale: String) {
        let chordPageView = ChordPage()
        let chordNames = getChordNames(from: rootScale)
        chordPageView.ChordPageView.backgroundColor = .clear
        chordPageView.configureButtonLabels(chordNames: chordNames)
        chordPageView.configureTitleLabel(rootNote: rootScale)
        chordPageView.tag = chordViewTag
        chordPageView.chordPageDelegate = self
        appendView(view: chordPageView)
    }
    func didSelectChord(chord: String, nthChord: Int, selectedScale: String) {
        guard let chordPage = viewHierarchy.last as? ChordPage else { return }
        for button in chordPage.Buttons {
            button.backgroundColor = .white
            button.layer.borderColor = lightPurple.cgColor
            button.setTitleColor(lightPurple, for: .normal)
        }
        isShowingChordIndicator = true
        self.nthChord = nthChord
        chordNumber = [1,3,5]
        for i in 0 ..< 3 {
            chordNumber[i] += nthChord
        }
        collectionView.reloadData()
    }
    
    func resetQuestions(){
        isTestChord = false
        chordNumber = [1,3,5]
        currentExercise = 1
    }
}
