require 'ncursesw'

include Ncurses

def conf
  {
    width: 100,
    height: 30,
    dead_cell: '░',
    live_cell: 'O'
  }
end

def main
  init_grid
  init_curses
  init_windows
  main_window
  main_loop
ensure
  Ncurses.endwin
end

def init_grid
  @grid = GridBuilder.new().create(conf[:width], conf[:height])
  @cells = @grid.cells
  @logic = Logic.new(@grid)
end

def init_windows
  sel = -1
  @gol = WINDOW.new(0,0,0,0)
  @gol.box(0,0)

  (1..conf[:height]).to_a.each do |y|
    (1...conf[:width]).to_a.each do |x|
      @gol.mvwaddstr(y,x,conf[:dead_cell])
    end
  end
  @gol.wmove(1,1)
  @gol.refresh
end

def main_window
  sel = nil

  while(sel != 113) do
    sel = @gol.getch

    x = []
    y = []

    @gol.getyx(y, x)
    @gol.refresh

    case sel
      when  65
        y[0] -= 1 if y[0] >= 2
      when  66
        y[0] += 1 if y[0] <= conf[:height] - 1
      when 67
        x[0] += 1 if x[0] <= conf[:width] - 2
      when 68
        x[0] -= 1 if x[0] >= 2
      when 120
        if @cells[ x[0] - 1][ y[0] - 1].status == 0
          @gol.addstr(conf[:live_cell])
          @cells[ x[0] - 1][ y[0] - 1].alive!
        else
          @gol.addstr(conf[:dead_cell])
          @cells[ x[0] - 1][ y[0] - 1].dead!
        end
    end

    @gol.wmove(y.first,x.first)
    @gol.refresh
  end
end

def main_loop
  @gol.timeout(1)
  generation = 0
  sel = nil

  while(sel != 113)
    sel = @gol.getch
    @logic.step
    generation += 1
    @cells.recurse_each_with_index do |r, x|
      r.recurse_each_with_index do |c, y|
        @gol.mvwaddstr( y + 1, x + 1, ( c.status == 1 ? conf[:live_cell] : conf[:dead_cell] ) )
      end
    end
    @gol.mvwaddstr( conf[:height] + 3, 2, "Generation #{generation}")
    @gol.refresh
  end
end

def init_curses
  Ncurses.initscr
  Ncurses.cbreak()
  Ncurses.noecho
end
