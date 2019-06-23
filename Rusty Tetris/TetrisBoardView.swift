import UIKit

class TetrisBoardView: UIView {
    private var blocks: [TetrisBlock]?

    func refresh(with blocks: [TetrisBlock]) {
        self.blocks = blocks
        setNeedsDisplay()
    }

    override func draw(_ rect: CGRect) {
        guard let blocks = self.blocks else {
            return
        }

        let backgroundRect = UIBezierPath(rect: rect)
        UIColor.black.setFill()
        backgroundRect.fill()


        for block in blocks {
            draw(block)
        }
    }

    func draw(_ block: TetrisBlock) {
        let ratio: CGFloat = 30
        let size = CGSize(width: ratio, height: ratio)
        let origin = CGPoint(x: CGFloat(block.x) * ratio, y: CGFloat(block.y) * ratio)
        let rect = CGRect(origin: origin, size: size)
        let path = UIBezierPath(rect: rect)

        block.color.setFill()
        path.fill()
    }

}
