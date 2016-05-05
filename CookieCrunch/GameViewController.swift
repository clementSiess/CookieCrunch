//
//  GameViewController.swift
//  CookieCrunch
//
//  Created by Siess, Clement on 9/24/15.
//  Copyright (c) 2015 Siess, Clement. All rights reserved.
//

import UIKit
import SpriteKit
import AVFoundation

class GameViewController: UIViewController {

    var scene: GameScene!
    var level: Level!
    
    var movesLeft = 0
    var score = 0
    var counter = 0
    var actualLevel = 1

    
    @IBOutlet weak var levelLabel: UILabel!
    @IBOutlet weak var targetLabel: UILabel!
    @IBOutlet weak var movesLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var gameOverPanel: UIImageView!
    @IBOutlet weak var shuffleButton: UIButton!
    
    var tapGestureRecognizer: UITapGestureRecognizer!
    
    lazy var backgroundMusic: AVAudioPlayer = {
        let url = NSBundle.mainBundle().URLForResource("Sounds/Mining by Moonlight", withExtension: "mp3")
        let player = try? AVAudioPlayer(contentsOfURL: url!)
        
        if let player = player {
            player.numberOfLoops = -1
            return player
        } else {
      
        return AVAudioPlayer()
        }
        }()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let skView = view as! SKView
        skView.multipleTouchEnabled = false
        
        scene = GameScene(size: skView.bounds.size)
        scene.scaleMode = .AspectFill
        
        selectGameLevel()
        scene.level = level
        scene.addTiles()
        
        scene.swipeHandler = handleSwipe
        
        gameOverPanel.hidden = true
        shuffleButton.hidden = true
        
        skView.presentScene(scene)
        
        backgroundMusic.play()
        
        beginGame()

    }
    
    func beginGame() {
        
        movesLeft = level.maximumMoves
        score = 0
        updateLabels()
        level.resetComboMultiplier()
        scene.animateBeginGame(){
        self.shuffleButton.hidden = false
        }
        shuffle()
    }
    
    func shuffle(){
        scene.removeAllCookieSprites()
        let newCookies = level.shuffle()
        scene.addSpritesForCookies(newCookies)
    }

    override func shouldAutorotate() -> Bool {
        return true
    }

    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return.AllButUpsideDown
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    func handleSwipe(swap: Swap) {
        view.userInteractionEnabled = false
        
        if level.isPossibleSwap(swap) {
            level.performSwap(swap)
            
            scene.animateSwap(swap, completion: handleMatches)
        } else {
                scene.animateInvalidSwap(swap) {
                self.view.userInteractionEnabled = true
            }
        }
    }
    
    func handleMatches() {
        
        let chains = level.removeMatches()
        if chains.count == 0 {
            beginNextTurn()
            return
        }
        
        scene.animateMatchedCookies(chains) {
            
            let columns = self.level.fillHoles()
            
            for chain in chains {
                self.score += chain.score
            }
            self.updateLabels()
            
            self.scene.animateFallingCookies(columns) {
                
                let columns = self.level.topUpCookies()
                
                self.scene.animateNewCookies(columns) {
                    self.handleMatches()
                }
                
            }
        }
    }
    
    func beginNextTurn() {
        level.detectPossibleSwaps()
        view.userInteractionEnabled = true
        decrementMoves()
    }
    
    func updateLabels() {
        targetLabel.text = String(format: "%ld", level.targetScore)
        movesLabel.text = String(format: "%ld", movesLeft)
        scoreLabel.text = String(format: "%ld", score)
    }
    
    func decrementMoves() {
        --movesLeft
        updateLabels()
        if score >= level.targetScore {
            gameOverPanel.image = UIImage(named: "LevelComplete")
            counter += 1
            actualLevel += 1

            showGameOver()
            
        } else if movesLeft == 0 {
            gameOverPanel.image = UIImage(named: "GameOver")
            showGameOver()
        }
    }
    
    func showGameOver() {
        gameOverPanel.hidden = false
        scene.userInteractionEnabled = false
        
        shuffleButton.hidden = true
        
        scene.animateGameOver() {
            self.selectGameLevel()
            self.tapGestureRecognizer = UITapGestureRecognizer(target: self, action: "hideGameOver")
            self.view.addGestureRecognizer(self.tapGestureRecognizer)
            
        }
        
    }
    
    
    func hideGameOver() {
        view.removeGestureRecognizer(tapGestureRecognizer)
        tapGestureRecognizer = nil
        
        gameOverPanel.hidden = true
        scene.userInteractionEnabled = true
        
        beginGame()
    }
    
    @IBAction func shuffleButtonPressed(_: AnyObject){
        shuffle()
        decrementMoves()
    }
    
    func selectGameLevel(){
        if counter == 0 {
            level = Level(filename: "Levels/Level_0")
            levelLabel.text = String("Level: \(actualLevel)")
        } else if counter == 1 {
            level = Level(filename: "Levels/Level_1")
            levelLabel.text = String("Level: \(actualLevel)")
            scene.level = level
            scene.addTiles()
        }else if counter == 2 {
            level = Level(filename: "Levels/Level_2")
            levelLabel.text = String("Level: \(actualLevel)")
            scene.level = level
            scene.addTiles()
        }else if counter == 3 {
            level = Level(filename: "Levels/Level_3")
            levelLabel.text = String("Level: \(actualLevel)")
            scene.level = level
            scene.addTiles()
        }else if counter == 4 {
            level = Level(filename: "Levels/Level_4")
            levelLabel.text = String("Level: \(actualLevel)")
            scene.level = level
            scene.addTiles()
        }else if counter == 5 {
            level = Level(filename: "Levels/Level_5")
            levelLabel.text = String("Level: \(actualLevel)")
            scene.level = level
            scene.addTiles()
        }else if counter >= 5{
            level = Level(filename: "Levels/Level_0")
            levelLabel.text = String("Level: \(actualLevel)")
            scene.level = level
            scene.addTiles()
        }
        
        
        
    }
    
//    override var level: String {
//        level = Level(filename: "Levels/Level_2")
//        return level
//    }
    
}
