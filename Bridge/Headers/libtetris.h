#include <stdarg.h>
#include <stdbool.h>
#include <stdint.h>
#include <stdlib.h>

typedef struct TetrisBlock {
  float red;
  float green;
  float blue;
  int32_t x;
  int32_t y;
} TetrisBlock;

void *tetris_game_create(uintptr_t height, uintptr_t width);

void tetris_game_free(void *game_ptr);

bool tetris_is_game_over(void *game_ptr);

void tetris_update(void *game_ptr, double delta_time);

void tetris_rotate(void *game_ptr);

void tetris_move_left(void *game_ptr);

void tetris_move_right(void *game_ptr);

void tetris_move_down(void *game_ptr);

size_t tetris_get_board(void *game_ptr, struct TetrisBlock **vec);
