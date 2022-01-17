
# Scalino

![App Screenshot](https://user-images.githubusercontent.com/53168317/149714666-0713c79b-7eee-41c9-b615-3ad82413ef22.jpeg)

Scalino is an app that helps hobbyist musicians to understand the basic concept of chords through **understanding** and **memorizing** music **scales**. By understanding basic chords and scales, it will make it **easier for musicians to create music**. This is the solution to the challenge because it could help **hobbyist musician to play chords** without having to **go back and forth looking for a chord tutorial.** 

The users can choose which **basic scale they want to learn (either major**), and we will provide them **tutorial on each scales** that show the **notes and intervals** before showing them the **chord structures**. There will be **exercises** on the **notes & intervals** so they will be able to **memorize and understand the notes, scales, and intervals better**. Our app will give a **real time feedback** if they hit the **right/wrong notes or chords**. Also, every time they play a certain chord, they will be given the **name of the chord**.


## Application Demo

https://youtu.be/xyt60SLyQxk 


## Documentation
### The Piano

On our application, we want to make a simple 2 octaves piano. The piano will have letter and numeric notation depending on the chosen music scale. We tried to make the piano using custom Collection View Cell. We first tried it to make just one octaves in one Collection View Cell. The individual notes itself are made of UIView with white and black background colors respectively. 

Then we use a simple loops in the Swift file to set the border width and colors of the UIViews. The UIViews and Labels are also connected to the Swift file through IBOutlets collections. 

<img width="704" alt="Screen_Shot_2021-06-29_at_13 18 16" src="https://user-images.githubusercontent.com/53168317/149715073-f7fc7743-807e-4942-a8ca-2d2b3605f1fc.png">

```swift
@IBOutlet var noteViews: [UIView]!
@IBOutlet var noteLabels: [UILabel]!
@IBOutlet var numericNoteLabels: [UILabel]!

override func awakeFromNib() {
    super.awakeFromNib()
    initializeNotesView()
}

private func initializeNotesView() {
    for noteView in noteViews {
        noteView.layer.borderWidth = 0.5
        noteView.layer.borderColor = UIColor.black.cgColor
    }
    for note in numericNoteLabels {
        note.textColor = lightPurple
        note.font = UIFont.systemFont(ofSize: 17, weight: .black)
    }
}
```

Because we used an XIB to build the cell, the Collection View in the Main View Controller have to register it first.

```swift
collectionView.register(UINib(nibName: "FullNotesCell", bundle: .main), forCellWithReuseIdentifier: "FullNotesCell")
```

After we registered it, now we can use the cell. So we used the dequeue reusable cell methods in the cellForItemAt function and use the numberOfCells function so we can dequeue the desired number of cells. Other than that we need to specify the height and width of every cell.

```swift
extension PianoVC: UICollectionViewDataSource {
		func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
				return numberOfOctaves //numberOfOctaves = 2
		}

		func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FullOctaveCell", for: indexPath) as? FullOctaveCell
        else { return UICollectionViewCell() }
        return cell
    }
}

// To specify the cell size
extension PianoVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: fullNotesCellWidth, height: collectionView.frame.height)
    }
}
```

Now that the visual of the piano is done and if you actually run the code above the piano should appear but you can't interact with it yet. Now we need to figure out what to do when users tap or press on the notes. We used a custom Long Press Gesture Recognizer that have 3 extra properties which are the UIViews of the notes, the Letter notation, and the numeric notation. Why we have to include those three properties? Because in our experience in using the Long Press Gesture Recognizer, we can't pass in parameters in the Obj-c target function, so we created the custom gesture and then pass in the whole class as the parameters. We need to use this because we have to change the UIView colors and some labels when the user press on the note itself.

```swift
// Custom gesture class
class NoteLongPressGesture: UILongPressGestureRecognizer {
    var notePressed: Int?
    var noteView: UIView?
    var noteLabel: UILabel?
}

// Function to configure the gesture to later be added to the individual note views
func generateGesture(notePressed: Int, noteLabel: UILabel, noteView: UIView) -> NoteLongPressGesture {
    let customGesture = NoteLongPressGesture()
    customGesture.minimumPressDuration = 0.01
    customGesture.notePressed = notePressed
    customGesture.noteLabel = noteLabel
    customGesture.noteView = noteView
    customGesture.addTarget(self, action: #selector(pianoNotePressed(_:)))
    return customGesture
}
```

Now that we have the custom gesture and the function to generate the gesture, we need to add the gesture recognizer to the note views. We can do it by using a loop inside the cellForItemAt function. so it should look something like this

```swift

func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FullOctaveCell", for: indexPath) as? FullOctaveCell
    else { return UICollectionViewCell() }

		var index = 0 // Counter Variable
		for noteView in cell.noteViews {
		    noteView.addGestureRecognizer(generateGesture(notePressed: index, noteLabel: cell.noteLabels[index], noteView: noteView))
		    index += 1
		}
    return cell   
}
```

And the last thing to add is the Obj-c function that will be called once the view recognize that there is a gesture being performed.

```swift
@objc func pianoNotePressed(_ sender: NoteLongPressGesture) {
		guard let notePressed = sender.notePressed,
          let noteView = sender.noteView,
          let noteLabel = sender.noteLabel
    else { return }
	
		if sender.state == .began {
        playSound(key: notePressed) // Function to play the piano sound, with the note index passed as parameter
        noteLabel.textColor = .white // To change the notation label color to white
        noteView.backgroundColor = Purple // To change the note views to purple when pressed 
    }
		else if sender.state == .ended {
				// And this is the part to change the colors back to it's original
				// We used the firstIndex function to determined whether the note is a white note or black note, then change the color accordingly
				noteLabel.textColor = PianoModel.blackNotesTag.firstIndex(of: notePressed) != nil ? .white : .black
				noteView.backgroundColor = PianoModel.blackNotesTag.firstIndex(of: notePressed) != nil ? .black : .white
		}
}
```

That's it. Of course it is much more complex than that, we have to figure out the hidden note logic and numeric note placement. And if i were to explain it here, it would be way too long. So if you're interested in knowing more, feel free to contact us!

### Protocols and delegate

In our application, we only use one view controller so the piano will be always accessible. We also designed it to be like an actual keyboard or digital piano that have a screen above the keys. So the smaller view in the middle will have actions such as when the button tap then it will change the views, or when the collection view cell for scales are tapped then the piano will have to update its numeric notation, etc. We could do it by using protocols and delegate.

![Simulator_Screen_Shot_-_iPhone_12_-_2021-06-29_at_13 55 57](https://user-images.githubusercontent.com/53168317/149715149-462f04ee-2bc6-4cc0-8dcf-c154a699a30a.png)

So for example in the Main Menu, there are three buttons for changing page. The Main Menu view itself were made with XIB and using a subclass of UIView. When we connect the button to the class as an IBAction, it needs to notify the Piano View Controller saying something like 'Hey, this button is tapped, so you have to do something'. The first thing to do is to create a protocols consisting of functions that will be called when the action happens. What we found was in order to make a function as optional, it needs to be a have the @objc keyword.

```swift
@objc protocol NavigationDelegate {
    @objc optional func navigateToLearn()
}
```

Now that we have the protocols, next is to add one property to the Main Menu View Class with the type of that protocol. Next is we can call the functions in that particular delegate inside the IBAction of the buttons.

```swift
class MainMenu: UIView {
		public weak var delegate: NavigationDelegate?

		@IBAction func learnButtonPressed(_ sender: UIButton) {
        delegate?.navigateToLearn?()
    }

		// Lines of codes...
}
```

So when the event happened, it will notify the delegates of this protocol and call the function automatically. Back to the Piano View Controller, we can make an extension and conform it to the NavigationDelegate protocol.  The Piano View Controller will act as the delegate of Main Menu View, so when the button was tapped, the main menu will execute the function inside of Piano View Controller.

```swift
extension PianoVC: NavigationDelegate {
		func navigateToLearn() {
				// This function will be called when the learn button in Main Menu was tapped.
				// Codes to change view here
		}
}
```
## Authors
- [Mutiara Sintesana Prasetyo - Project Manager](https://www.linkedin.com/in/mutiara-prasetyo-09448513a/)
- [Nataniel Christandy - UI/UX Designer](https://www.linkedin.com/in/nataniel-christandy-0570911b9/)
- [Nico Christian - iOS Engineer](https://www.linkedin.com/search/results/all/?keywords=nico%20christian&origin=RICH_QUERY_SUGGESTION&position=0&searchId=ae782b90-e697-454c-b338-ca919dcca85d)
- [Javier Fransiscus - iOS Engineer](https://www.linkedin.com/in/javier-fransiscus/)
- [Fernando Lawrence - iOS Engineer](https://www.linkedin.com/in/fernandolawrence/)
- [Ivan Valentino Sigit - iOS Engineer](https://www.linkedin.com/in/ivanvsigit/)


