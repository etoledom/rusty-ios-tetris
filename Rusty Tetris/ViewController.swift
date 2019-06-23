import UIKit

class ViewController: UIViewController {
    var game: Tetris = Tetris(height: 20, width: 10)

    var controls: ControlsViewController? {
        didSet {
            controls?.onActionButtonPressed = { [weak self] (action) in
                self?.game.perform(action)
            }
        }
    }

    @IBOutlet weak var boardView: TetrisBoardView!

    override func viewDidLoad() {
        super.viewDidLoad()
        startLoop()
    }

    func startLoop() {
        let refreshRate = 0.03;

        Timer.scheduledTimer(withTimeInterval: refreshRate, repeats: true) { [weak self] (timer) in
            guard let self = self else {
                return
            }

            self.game.update(deltaTime: timer.timeInterval);
            let blocks = self.game.draw()
            self.boardView.refresh(with: blocks)
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.destination {
        case let controller as ControlsViewController:
            controls = controller
        default:
            break
        }
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        DispatchQueue.main.async {
            self.boardView.boardSize = self.game.size
        }
    }
}
