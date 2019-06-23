import UIKit

class ViewController: UIViewController {
    var game: Tetris = Tetris(height: 20, width: 10)
    var gameBlocks: [TetrisBlock]?

    lazy var boardView: TetrisBoardView = {
        let view = TetrisBoardView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupBoard()
        startLoop()
    }

    func setupBoard() {
        view.addSubview(boardView)
        NSLayoutConstraint.activate([
            boardView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            boardView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            boardView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            boardView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
    }

    func startLoop() {
        let refreshRate = 0.2;

        Timer.scheduledTimer(withTimeInterval: refreshRate, repeats: true) { [weak self] (timer) in
            guard let self = self else {
                return
            }

            self.game.update(deltaTime: timer.timeInterval);
            let blocks = self.game.draw()
            self.boardView.refresh(with: blocks)
        }
    }
}
