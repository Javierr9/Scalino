//
//  PianoModel.swift
//  MVC-Template
//
//  Created by Mutiara Prasetyo on 09/06/21.
//

import Foundation

class PianoModel {
    static let fullNotes: [String] = ["C", "C#", "D", "Eb", "E", "F", "F#", "G", "Ab", "A", "Bb", "B", "C", "C#", "D", "Eb", "E", "F", "F#", "G", "Ab", "A", "Bb", "B", "C", "C#", "D", "Eb", "E", "F", "F#", "G", "Ab", "A", "Bb", "B"]
    static let intervals: [Int] = [0, 2, 2, 1, 2, 2, 2, 1, 2, 2, 1, 2, 2, 2, 1]
    static let notesInChord: [Int] = [0, 2, 4]
    static let chordTypes: [String] = ["Major", "Minor", "Minor", "Major", "Major", "Minor", "Diminished"]
    static let blackNotesTag: [Int] = [1, 3, 6, 8, 10, 13, 15, 18, 20, 22]
}

func getNotesInScale(from note: String) -> [String] {
    var notesInScale: [String] = []
    let fullNotes = PianoModel.fullNotes
    let intervals = PianoModel.intervals
    guard var currentNote = fullNotes.firstIndex(of: note) else { return [""] }
    for currentInterval in 0 ..< intervals.count {
        currentNote += intervals[currentInterval]
        notesInScale.append(fullNotes[currentNote])
    }
    return notesInScale
}

func getNotesInChord(from scale: String) -> [[String]] {
    let notesInScale = getNotesInScale(from: scale)
    var notesInChord = PianoModel.notesInChord
    var fullChordsAndNotes: [[String]] = []
    
    for currentChord in 0 ..< 7 {
        fullChordsAndNotes.append([notesInScale[notesInChord[0]]])
        for currentNote in 1 ..< 3 {
            fullChordsAndNotes[currentChord].append(notesInScale[notesInChord[currentNote]])
        }
        notesInChord[0] = notesInChord[0] + 1
        notesInChord[1] = notesInChord[1] + 1
        notesInChord[2] = notesInChord[2] + 1
    }
    return fullChordsAndNotes
}

func getChordNames(from scale: String) -> [String] {
    let notesInScale = getNotesInScale(from: scale)
    var fullChordName: [String] = []
    for currentNote in 0 ..< 7 {
        fullChordName.append("\(notesInScale[currentNote]) \(PianoModel.chordTypes[currentNote])")
    }
    return fullChordName
}

func getScaleAnswer(from scale: String) -> [Int]{
    guard let rootNote = PianoModel.fullNotes.firstIndex(of: scale) else { return [] }
    var correctAnswer: [Int] = []
    var currentNote = rootNote
    for index in 0 ..< 14 {
        correctAnswer.append(currentNote + PianoModel.intervals[index])
        currentNote += PianoModel.intervals[index]
    }
    return correctAnswer
}
