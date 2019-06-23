import UIKit

class ControlsViewController: UIViewController {

    var onActionButtonPressed: ((Tetris.Action) -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func onLeftButtonPressed(_ sender: Any) {
        onActionButtonPressed?(.left)
    }

    @IBAction func onDownButtonPressed(_ sender: Any) {
        onActionButtonPressed?(.down)
    }

    @IBAction func onRightButtonPressed(_ sender: Any) {
        onActionButtonPressed?(.right)
    }

    @IBAction func onRotateButtonPressed(_ sender: Any) {
        onActionButtonPressed?(.rotation)
    }
}
