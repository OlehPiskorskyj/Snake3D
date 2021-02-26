//
//  Main.swift
//  Snake3D
//
//  Created by Oleh Piskorskyj on 23/02/2021.
//

import UIKit

class Main: UIViewController {
    
    // MARK: - props
    @IBOutlet weak var viewSnake: Snake!
    @IBOutlet weak var lblScore: UILabel!
    
    private var alert: Alert? = nil
    
    // MARK: - vc life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewSnake.scoreChanged = { [weak self] (score: Int) in
            self?.lblScore.text = String(format: "Score: %d", score)
        }
        
        viewSnake.gameOver = { [weak self] (score: Int) in
            self?.alert = Alert(parentView: self?.view, title: "Game Over", message: String(format: "Your score is: %d", score), cancelTitle: "Quit", okTitle: "Retry")
            self?.alert?.cancelAction = {
                exit(0)
            }
            self?.alert?.okAction = { [weak self] in
                self?.viewSnake.retry()
            }
            self?.alert?.show()
        }
    }
}
