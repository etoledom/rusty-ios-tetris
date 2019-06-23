import UIKit

class TetrisBoardView: UIView {
    var boardSize: CGSize = .zero {
        didSet {
            calculateDimentions()
        }
    }

    private var blocks: [TetrisBlock]?
    private var ratio: CGFloat = 0
    private var leftMarging: CGFloat = 0
    private var boardRect: CGRect = .zero

    func refresh(with blocks: [TetrisBlock]) {
        assert(boardSize != .zero, "Must set boardSize")
        self.blocks = blocks
        setNeedsDisplay()
    }

    func calculateDimentions() {
        calculateRatio()
        calculateLeftMargin()
        calculateBoardRect()
    }

    private func calculateRatio() {
        ratio = bounds.width / boardSize.width
        if ratio * boardSize.height > bounds.height {
            ratio = bounds.height / boardSize.height
        }
    }

    private func calculateLeftMargin() {
        let realBoardWidth = (ratio * boardSize.width)
         self.leftMarging = round((bounds.width - realBoardWidth) / 2)
    }

    private func calculateBoardRect() {
        let realBoardSize = CGSize(width: ratio * boardSize.width, height: ratio * boardSize.height)
        self.boardRect = CGRect(origin: CGPoint(x: self.leftMarging, y: 0), size: realBoardSize)
    }

    override func draw(_ rect: CGRect) {
        guard let blocks = self.blocks else {
            return
        }

        let backgroundRect = UIBezierPath(rect: self.boardRect)
        UIColor.white.setStroke()
        UIColor.black.setFill()
        backgroundRect.fill()
        backgroundRect.stroke()

        for block in blocks {
            draw(block)
        }
    }

    func draw(_ block: TetrisBlock) {
        let size = CGSize(width: ratio, height: ratio)
        let origin = CGPoint(x: CGFloat(block.x) * ratio + self.leftMarging, y: CGFloat(block.y) * ratio)
        let rect = CGRect(origin: origin, size: size)
        let path = UIBezierPath(rect: rect)

        block.color.setFill()
        path.fill()
    }

}
