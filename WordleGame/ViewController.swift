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
        
        for i in 0...randowWordArr.count - 1 {
            if (randowWordArr.contains(guess[i]) && randowWordArr[i] == guess[i]){
                changeColorToGreen(textVal: guess[i],slicedArr: getSplicedArr())
            }
            else if (randowWordArr.contains(guess[i]) && randowWordArr[i] != guess[i]){
                changeColorToYellow(textVal: guess[i],slicedArr: getSplicedArr())

            } else {
                changeColorToGray(textVal: guess[i],slicedArr: getSplicedArr())
            

            }
        }
        
        if(randomWord == String(guess)){
            let okAction = UIAlertAction(title: "Play Again", style: .default){
                action in print("OK Clikced!!!")
                self.resetBoard()
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
        for i in (0...getSplicedArr().count - 1).reversed() {
            if (getSplicedArr()[i].text != ""){
                getSplicedArr()[i].text = ""
                guess.remove(at: i)
                break
            }
        }
        submitBtn.isEnabled = false
    }
    
    
    func changeColorToGreen(textVal: Character,slicedArr: Array<UITextField>){
        for i in 0...slicedArr.count - 1{
            if slicedArr[i].text == String(textVal) {
                slicedArr[i].backgroundColor = UIColor(red: 83.0/255, green: 141.0/255, blue: 78.0/255, alpha: 1.0)
                
            }
        }
    }
 func changeColorToYellow(textVal: Character,slicedArr: Array<UITextField>){
        for i in 0...slicedArr.count - 1{
            if slicedArr[i].text == String(textVal) {
                slicedArr[i].backgroundColor = UIColor(red: 180.0/255, green: 159.0/255, blue: 58.0/255, alpha: 1.0)
            }
        }
    }
    func changeColorToGray(textVal: Character,slicedArr: Array<UITextField>){
        for i in 0...slicedArr.count - 1{
            if slicedArr[i].text == String(textVal) {
                slicedArr[i].backgroundColor = UIColor(red: 58.0/255, green: 58.0/255, blue: 60.0/255, alpha: 1.0)
                slicedArr[i].textColor = UIColor.white
            }
        }
    }
    
    func showValInColumn(keyVal: Character)  {
        for  index in 0...getSplicedArr().count - 1{
           
            if(getSplicedArr()[index].tag == 5 || getSplicedArr()[index].tag == 10 || getSplicedArr()[index].tag == 15 ||  getSplicedArr()[index].tag == 20 || getSplicedArr()[index].tag == 25 || getSplicedArr()[index].tag == 30){
                submitBtn.isEnabled = true
            }
            //insert val in 1st column
            if(getSplicedArr()[index].text == "" && index == 0){
                getSplicedArr()[index].text = String(keyVal)
                guess.append(keyVal)
                break
            }
            //insert val in next col
            if (getSplicedArr()[index].text == "" && getSplicedArr()[index - 1].text != ""){
                getSplicedArr()[index].text = String(keyVal)
                guess.append(keyVal)
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
    
    func getSplicedArr() -> Array<UITextField>{
        if(turns == 2){
           return Array(textFieldArr[5...9])
        }
        else if ( turns == 3 ){
            return Array(textFieldArr[10...14])

        }
        else if ( turns == 4 ){
            return Array(textFieldArr[15...19])

        }
        else if ( turns == 5 ){
            return Array(textFieldArr[20...24])

        }
        else if ( turns == 6 ){
            return Array(textFieldArr[25...29])

        }
        else{
            return Array(textFieldArr[0...4])
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
        
    func getRandomWord() -> String {
        let wordArr = ["HOUSE","BEARS","TRACE","BLUES","SWIFT","CRACK","HONEY","ALONG","SHINE","SHARP","EARTH"]
        return wordArr.randomElement()!
    }
    
}
