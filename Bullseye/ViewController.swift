//
//  ViewController.swift
//  Bullseye
//
//  Created by Amanda Goldberg on 3/23/18.
//  Copyright © 2018 Amanda Goldberg. All rights reserved.
//

import UIKit
import QuartzCore
//import Cheers

class ViewController: UIViewController {
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var roundLabel: UILabel!
    var currentValue = 0
    var targetValue = 0
    var score = 0
    var round = 0


    
//    let cheerView = CheerView()

    override func viewDidLoad() {
        super.viewDidLoad()
      
        startNewGame()
        
        let thumbImageNormal = #imageLiteral(resourceName: "SliderThumb-Normal")
        slider.setThumbImage(thumbImageNormal, for: .normal)
        
        let thumbImageHighLighted = #imageLiteral(resourceName: "SliderThumb-Highlighted")
        slider.setThumbImage(thumbImageHighLighted, for: .highlighted)
        
        let insets = UIEdgeInsets (top: 0, left: 14, bottom: 0, right: 14)
        
        let tracklLeftImage = #imageLiteral(resourceName: "SliderTrackLeft")
        let trackLeftResizable =
            tracklLeftImage.resizableImage(withCapInsets: insets)
        slider.setMinimumTrackImage(trackLeftResizable, for: .normal)
        
        let trackRightImage = #imageLiteral(resourceName: "SliderTrackRight")
        let trackRightResizable =
            trackRightImage.resizableImage(withCapInsets: insets)
        slider.setMaximumTrackImage(trackRightResizable, for: .normal)
        
//        view.addSubview(cheerView)
//        cheerView.config.particle = .confetti(allowedShapes: Particle.ConfettiShape.all)
    }
    
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

    @IBAction func startNewGame() {
        score = 0
        round = 0
        startNewRound()
        let transition = CATransition()
//        transition.type = CATransitionType.fade
        transition.duration = 1
//        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeOut)
        view.layer.add(transition, forKey: nil)
    }
    
    func startNewRound(){
        round += 1
        targetValue = 1 + Int(arc4random_uniform(100))
        currentValue = 50
        slider.value = Float(currentValue)
        updateLabels()
    }
    
    func updateLabels() {
        targetLabel.text = String(targetValue)
        scoreLabel.text = String(score)
        roundLabel.text = String(round)
    }
    
    @IBOutlet weak var targetLabel: UILabel!
    
    @IBAction func showAlert() {
        let difference = abs(targetValue - currentValue)
        var points = 100 - difference
        let title: String
        if difference == 0 {
            title = "Perfect!"
            points += 100
//            cheerView.start()
//            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
//                self.cheerView.stop()
//            }
        } else if difference < 5 {
            title = "You almost had it!"
            if difference == 1 {
                points += 50
//                cheerView.start()
//                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
//                    self.cheerView.stop()
//                }
            }
        } else if difference < 10 {
            title = "Pretty good!"
        } else {
            title = "Not even close..."
        }
        score += points
        
//        let eventRecorded = NewRelic.recordCustomEvent("iOSCustomEventTest", attributes:["make":"Ford", "model":"ModelT", "year": 1908, "color": "black", "mileage": 250000]);
        
        

        
        let message = "Yay! You scored \(points) points this time!!!"
        NewRelic.crashNow("testing if bitrise sent dsyms")
        

        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: .alert)
        
        let action = UIAlertAction(title: "OK", style: .default,
                                   handler: { action in
                                                self.startNewRound()
                                            })
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    

    @IBAction func sliderMoved(_ slider: UISlider) {
        currentValue = lroundf(slider.value)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
//        cheerView.frame = view.bounds
    }
    
    
    
    func networkCall (asyncCallBack: @escaping (Int) -> ()){
        // get URL shared session singleton for most basic network requests
        let sharedSession = URLSession.shared
        
        //this is similar guard, to check for null, using optional ability of swift
        if let url = URL(string: "https://goo.gl/wV9G4I"){
            let request = URLRequest(url: url)
            let dataTask = sharedSession.dataTask(with: url, completionHandler: {(data, response, error)-> Void in
                if let response = response as? HTTPURLResponse {
                    DispatchQueue.main.async {
                        asyncCallBack(response.statusCode)
                    }
                }
            })
            dataTask.resume()
        }
    }
    
}


