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
    
    // MARK: - vc life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewSnake.scoreChanged = { [weak self] (score: Int) in
            self?.lblScore.text = String(format: "Score: %d", score)
        }
        
        viewSnake.gameOver = { [weak self] (score: Int) in
            let alert = UIAlertController(title: "Game Over", message: String(format: "Your score is: %d", score), preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Quit", style: .cancel, handler: { (action) in
                exit(0)
            }))
            alert.addAction(UIAlertAction(title: "Retry", style: .default, handler: { [weak self] (action) in
                self?.viewSnake.retry()
            }))
            self?.present(alert, animated: true)
        }
    }
}
