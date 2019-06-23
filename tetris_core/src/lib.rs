use std::os::raw::*;
use tetris_core::*;

#[allow(non_camel_case_types)]
type size_t = usize;

struct Rand;
impl Randomizer for Rand {
    fn random_between(&self, _first: i32, _last: i32) -> i32 {
        return 2;
    }
}

#[repr(C)]
#[derive(Debug)]
pub struct TetrisBlock {
    red: f32,
    green: f32,
    blue: f32,
    x: i32,
    y: i32,
}

#[no_mangle]
pub extern "C" fn tetris_game_create(height: usize, width: usize) -> *mut c_void {
    let size = Size { height, width };
    let rand = Rand;
    let game = tetris_core::Game::new(&size, Box::new(rand));
    let boxed = Box::new(game);
    return Box::into_raw(boxed) as *mut c_void;
}

#[no_mangle]
pub extern "C" fn tetris_game_free(game_ptr: *mut c_void) {
    let _game = unsafe { Box::from_raw(game_ptr as *mut Game) };
}

#[no_mangle]
pub extern "C" fn tetris_is_game_over(game_ptr: *mut c_void) -> bool {
    let game = get_game_from_ptr(game_ptr);
    return game.is_game_over();
}

#[no_mangle]
pub extern "C" fn tetris_update(game_ptr: *mut c_void, delta_time: f64) {
    let game = get_game_from_ptr(game_ptr);
    game.update(delta_time);
}

#[no_mangle]
pub extern "C" fn tetris_rotate(game_ptr: *mut c_void) {
    let game = get_game_from_ptr(game_ptr);
    game.rotate();
}

#[no_mangle]
pub extern "C" fn tetris_move_left(game_ptr: *mut c_void) {
    let game = get_game_from_ptr(game_ptr);
    game.move_left();
}

#[no_mangle]
pub extern "C" fn tetris_move_right(game_ptr: *mut c_void) {
    let game = get_game_from_ptr(game_ptr);
    game.move_right();
}

#[no_mangle]
pub extern "C" fn tetris_move_down(game_ptr: *mut c_void) {
    let game = get_game_from_ptr(game_ptr);
    game.move_down();
}

fn board_blocks_from(game: &Game) -> Vec<TetrisBlock> {
    return game
        .draw()
        .iter()
        .map(|block| TetrisBlock {
            red: block.color.red,
            green: block.color.green,
            blue: block.color.blue,
            x: block.rect.origin.x,
            y: block.rect.origin.y,
        })
        .collect();
}

#[no_mangle]
pub extern "C" fn tetris_get_board(game_ptr: *mut c_void, vec: *mut *mut TetrisBlock) -> size_t {
    let game = get_game_from_ptr(game_ptr);
    let mut board = board_blocks_from(game);

    board.shrink_to_fit();
    let length = board.len();
    unsafe { *vec = board.as_mut_ptr() };
    std::mem::forget(board);
    return length;
}

fn get_game_from_ptr<'a>(ptr: *mut c_void) -> &'a mut Game {
    let game_box = unsafe { Box::from_raw(ptr as *mut Game) };
    return Box::leak(game_box);
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_get_board() {
        let game_ptr = tetris_game_create(2, 2);
        let mut buffer: *mut TetrisBlock = std::ptr::null_mut();
        let size = tetris_get_board(game_ptr, &mut buffer as *mut *mut TetrisBlock);

        unsafe {
            let vec = Vec::from_raw_parts(buffer, size, size);
            assert_eq!(vec[0].x, 1);
            assert_eq!(vec[1].x, -1);
            assert_eq!(vec[2].x, 0);
            assert_eq!(vec[3].x, 1);
        }

        assert_eq!(size, 4);
    }
}
