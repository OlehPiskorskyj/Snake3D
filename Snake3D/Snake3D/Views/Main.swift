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
    @IBOutlet weak var lblInfo: UILabel!
    
    private var alert: Alert? = nil
    private var score: Int = 0 {
        didSet {
            /*
            if (score > 0) {
                lblScore.text = String(format: "Score: %d", score)
                if (lblScore.alpha == 0.0) {
                    UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveEaseInOut) { [weak self] in
                        self?.lblScore.alpha = 1.0
                    }
                }
            } else {
                lblScore.alpha = 0.0
            }
            */
            lblScore.text = String(format: "Score: %d", score)
        }
    }
    
    // MARK: - vc life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewSnake.scoreChanged = { [weak self] (score: Int) in
            self?.score = score
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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        lblInfo.pulseAnimation(repeatCount: 3)
    }
}
