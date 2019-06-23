import UIKit
import CoreGraphics

class Tetris {
    enum Action {
        case left, right, down, rotation
    }

    let size: CGSize
    private let gamePtr: UnsafeMutableRawPointer

    init(height: UInt, width: UInt) {
        gamePtr = tetris_game_create(height, width)
        size = CGSize(width: Int(width), height: Int(height))
    }

    deinit {
        tetris_game_free(gamePtr)
    }

    var isGameOver: Bool {
        return tetris_is_game_over(gamePtr)
    }

    func update(deltaTime: Double) {
        tetris_update(gamePtr, deltaTime)
    }

    func perform(_ action: Action) {
        switch action {
        case .left:
            tetris_move_left(gamePtr)
        case .right:
            tetris_move_right(gamePtr)
        case .down:
            tetris_move_down(gamePtr)
        case .rotation:
            tetris_rotate(gamePtr)
        }
    }

    func draw() -> [TetrisBlock] {
        let arrayRefPtr = UnsafeMutablePointer<UnsafeMutablePointer<TetrisBlock>?>.allocate(capacity: 0)
        let length = tetris_get_board(gamePtr, arrayRefPtr)

        guard let cArrayPtr = arrayRefPtr.pointee else {
            assertionFailure()
            return []
        }

        let buffer = UnsafeMutableBufferPointer(start: cArrayPtr, count: length)
        defer {
            free(arrayRefPtr)
            free(buffer.baseAddress)
        }

        return Array(buffer)
    }
}

extension TetrisBlock {
    var color: UIColor {
        return UIColor(red: CGFloat(red), green: CGFloat(green), blue: CGFloat(blue), alpha: 1)
    }
}
