//
//  ViewController.swift
//  WordleGame
//
//  Created by Ankur Kalson on 2022-10-18.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var vertical_stack: UIStackView!
    
    @IBOutlet weak var del_btn: UIButton!
    var turns = 1

    var randomWord: String = ""
    var checker: UITextChecker = UITextChecker()
    
    @IBOutlet weak var keyboardView: UIView!
    var textFieldArr  = [UITextField]()
    var guess:[Character] = []
    @IBOutlet weak var submitBtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        randomWord = getRandomWord()
        storeTextFieldInArray()
        for view in vertical_stack.subviews {
            if let h_stack = view as? UIStackView{
                for h_stack in h_stack.subviews{
                    h_stack.layer.borderWidth = 1.0
                    h_stack.layer.borderColor = UIColor(red: 58.0/255, green: 58.0/255, blue: 60.0/255, alpha: 1.0).cgColor
                    h_stack.backgroundColor = UIColor(red: 18.0/255, green: 18.0/255, blue: 19.0/255, alpha: 1.0)
                    
                }
            }
        }
        submitBtn.isEnabled = false
        submitBtn.setTitle("Submit", for: .disabled)
        submitBtn.setTitle("Submit", for: .normal)
        view.backgroundColor = UIColor(red: 18.0/255, green: 18.0/255, blue: 19.0/255, alpha: 1.0)
        print("random ",randomWord)

    }
    
    @IBAction func keyboardPres(sender: UIButton) {
        if let text = sender.titleLabel?.text {
            showValInColumn(keyVal: Character(text))
        }
    }
    
    @IBAction func submitAction(_ sender: Any) {
        var randowWordArr = [Character]()
        
        for char in randomWord {
            randowWordArr.append(char)
        }
        
        print("randowm: ",randowWordArr)
        print(guess)
        
        let greenColor = UIColor(red: 83.0/255, green: 141.0/255, blue: 78.0/255, alpha: 1.0)
        let yellowColor = UIColor(red: 180.0/255, green: 159.0/255, blue: 58.0/255, alpha: 1.0)
        let grayColor = UIColor(red: 58.0/255, green: 58.0/255, blue: 60.0/255, alpha: 1.0)
        
        //checking duplicates
        let randomWordHasDuplicates = randowWordArr.count != Set(randowWordArr).count
        let guessHasDuplicates = guess.count != Set(guess).count

        
        for i in 0...randowWordArr.count - 1 {
            if (randowWordArr.contains(guess[i]) && randowWordArr[i] == guess[i]){
                
                changeTextFieldColor(textVal: guess[i],splicedArr: getSplicedArr(index: i),color: greenColor)
                
                changeKeyColor(textVal: guess[i],color: greenColor)
            }
            else if (randowWordArr.contains(guess[i]) && randowWordArr[i] != guess[i]){
                changeTextFieldColor(textVal: guess[i],splicedArr: getSplicedArr(index: i),color: yellowColor)
                changeKeyColor(textVal: guess[i],color:yellowColor)
            }
            else {
                changeTextFieldColor(textVal: guess[i],splicedArr: getSplicedArr(index: i),color: grayColor)
                changeKeyColor(textVal: guess[i],color: grayColor)
                
            }
        }
            
            // check for duplicates
        var flag = 1
            if(!randomWordHasDuplicates && guessHasDuplicates){
                for j in 0...guess.count - 1 {
                    for k in 1...guess.count - 1 {
                        if flag == 5{
                            break
                        }
                            
                        if guess[j] == guess[flag] {
                            //check the colors of the textfield, if both yellow turn the second one gray
                            if(getSplicedArr(index: 0)[j].backgroundColor == greenColor){
                                getSplicedArr(index: 0)[k].backgroundColor = grayColor
                            }
                        }
                        flag += 1
                    }
                }
            }
           
        if(randomWord == String(guess)){
            let okAction = UIAlertAction(title: "Play Again", style: .default){
                action in print("OK Clikced!!!")
                self.resetBoard()
                self.resetKeyboard()
            }
            let alert = UIAlertController(title: "WOOHOO!", message: "You Got The Word!", preferredStyle: .alert)
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)
            turns = 1
            guess.removeAll()
            submitBtn.isEnabled = false
            randomWord = getRandomWord()
        }
        else if(randomWord != String(guess) && turns == 6){
            let okAction = UIAlertAction(title: "Play Again", style: .default){
                action in print("OK Clikced!!!")
                self.resetBoard()
                self.resetKeyboard()
            }
            let alert = UIAlertController(title: "You ran out of luck!", message: "Word was \(randomWord)", preferredStyle: .alert)
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)
            turns = 1
            guess.removeAll()
            submitBtn.isEnabled = false
            randomWord = getRandomWord()
        }
        else{
            turns += 1
            guess.removeAll()
            submitBtn.isEnabled = false
        }
    }
    
    @IBAction func deleteAction(_ sender: Any) {
        let arr = getSplicedArr(index: 0)

        for i in (0...arr.count - 1).reversed() {
            if (arr[i].text != ""){
                arr[i].text = ""
                guess.remove(at: i)
                break
            }
        }
        submitBtn.isEnabled = false
    }
    
    
    func changeTextFieldColor(textVal: Character,splicedArr: Array<UITextField>,color: UIColor){
        for i in 0...splicedArr.count - 1{
            if splicedArr[i].text == String(textVal) {
                splicedArr[i].backgroundColor = color
            }
        }
    }

    func changeKeyColor(textVal: Character, color: UIColor){
        for view in  keyboardView.subviews {
            if let row = view as? UIStackView{
                for subview in row.subviews {
                    let button = subview as? UIButton
                    if let btnText = button?.titleLabel?.text {
                        if(btnText == String(textVal)){
                            button?.backgroundColor = color
                        }
                    }
                }
            }
        }
    }
    
    
    func showValInColumn(keyVal: Character)  {
        let arr = getSplicedArr(index: 0)
        for  index in 0...arr.count - 1 {
           
          
            //insert val in 1st column
            if(arr[index].text == "" && index == 0){
                arr[index].text = String(keyVal)
                guess.append(keyVal)
                break
            }
            //insert val in next col
            if (arr[index].text == "" && arr[index - 1].text != ""){
                arr[index].text = String(keyVal)
                guess.append(keyVal)
                if(arr[index].tag == 5 || arr[index].tag == 10 || arr[index].tag == 15 ||  arr[index].tag == 20 || arr[index].tag == 25 || arr[index].tag == 30){
                    print(String(guess), isWordReal(word: String(guess)))

                        submitBtn.isEnabled = true
                }
                break
            }
          
        }
    }
    
    func storeTextFieldInArray (){
        for view in vertical_stack.subviews {
            if let h_stack = view as? UIStackView{
                for subview in h_stack.subviews {
                    if let label = subview as? UITextField {
                            textFieldArr.append(label)
                        }
                    }
                }
            }
        }
    
    func disableKeyboard (){
        for view in  keyboardView.subviews {
            if let row = view as? UIStackView{
                for subview in row.subviews {
                    let button = subview as? UIButton
                    //28 tag is for submit button
                    if ( button?.tag != 28 && button?.tag != 27) {
                        button?.isEnabled = false
                        }
                    }
                }
            }
            submitBtn.isEnabled = true


    }

  

//tried adding the word spell check but always gives true for all the words
    func isWordReal(word: String) -> Bool {
        let word_lowercase = word.lowercased()

        let checker = UITextChecker()
          let range = NSRange(location: 0, length: word_lowercase.utf16.count)
          let mispelledRange = checker.rangeOfMisspelledWord(in: word, range: range, startingAt: 0, wrap: false, language: "en")

          return mispelledRange.location == NSNotFound
        
    }
    
    func getSplicedArr(index: Int) -> Array<UITextField>{
        if(turns == 1){
            return Array(textFieldArr[index...4])
        }
        else if ( turns == 2 ){
            return Array(textFieldArr[(index + 5)...9])
        }
        else if ( turns == 3 ){
            return Array(textFieldArr[(index + 10)...14])
        }
        else if ( turns == 4 ){
            return Array(textFieldArr[(index + 15)...19])
        }
        else if ( turns == 5 ){
            return Array(textFieldArr[(index + 20)...24])
        }
        else{
            return Array(textFieldArr[(index + 25)...29])
        }
    }
    
    func resetBoard(){
        for view in vertical_stack.subviews {
            if let h_stack = view as? UIStackView{
                for subview in h_stack.subviews {
                    if let label = subview as? UITextField {
                        label.text = ""
                        label.backgroundColor = UIColor(red: 18.0/255, green: 18.0/255, blue: 19.0/255, alpha: 1.0)
                    }
                }
            }
        }
    }
    
    func resetKeyboard(){
        for view in  keyboardView.subviews {
            if let row = view as? UIStackView{
                for subview in row.subviews {
                    let button = subview as? UIButton
                        if ( button?.tag != 28 && button?.tag != 27) {
                            button?.backgroundColor = UIColor(red: 128.0/255, green: 131.0/255, blue: 132.0/255, alpha: 1.0)
                        }
                    }
                }
        }
    }
    
    func getRandomWord() -> String {
        let wordArr = ["HOUSE","BEARS","TRACE","BLUES","SWIFT","CRACK","HONEY","ALONG","SHINE","SHARP","EARTH"]
        
//        let wordArr = ["CRACK"]
        return wordArr.randomElement()!
        
    }
    
}

