require 'ncursesw'

class Screen
  include Ncurses

  attr_reader :conf

  def initialize(conf)
    init_curses
    @conf = conf
    init_grid
    init_window
    setup_cells
    run_logic
  ensure
    clean_up
  end

  def init_grid
    @grid = GridBuilder.new.create(conf['width'], conf['height'])
    @cells = @grid.cells
    @logic = Logic.new(@grid)
  end

  def init_curses
    Ncurses.initscr
    Ncurses.cbreak
    Ncurses.noecho
  end

  def clean_up
    Ncurses.echo
    Ncurses.nl
    Ncurses.endwin
  end

  def init_window
    @gol = WINDOW.new(*conf['window']['dimensions'])
    @gol.box(*conf['window']['box'])
    update_cells
    display_help
  end

  def update_cells
    @cells.recurse_each_with_index do |r, x|
      r.recurse_each_with_index do |c, y|
        set_cell_status(y, x, determine_cell_char(c))
      end
    end
    @gol.refresh
  end

  def set_cell_status(y, x, char)
    @gol.mvwaddstr(y + conf['y_offset'], x + conf['x_offset'], char)
  end

  def determine_cell_char(cell)
    (cell.alive? && conf['live_cell']) || conf['dead_cell']
  end

  def handle_key_event(keyn)
    handle_key?(keyn) && send("event_#{key_map[keyn]}")
  end

  def handle_key?(keyn)
    key_map.keys.include?(keyn)
  end

  def setup_cells
    wait_for_key
  end

  def wait_for_key
    key = @gol.getch
    handle_key_event key
    @gol.refresh
    key != conf['key_continue'] && wait_for_key
  end

  def event_up
    y, x = *getyx
    y >= conf['y_upper_limit'] && (y -= 1)
    set_cursor(y, x)
  end

  def event_down
    y, x = *getyx
    y <= conf['height'] - conf['y_offset'] && (y += 1)
    set_cursor(y, x)
  end

  def event_left
    y, x = *getyx
    x >= conf['x_left_limit'] && (x -= 1)
    set_cursor(y, x)
  end

  def event_right
    y, x = *getyx
    x <= conf['width'] - conf['x_offset'] && (x += 1)
    set_cursor(y, x)
  end

  def event_space
    y, x = *getyx
    toggle_cell(y, x)
    update_cells
    set_cursor(y, x)
  end

  def toggle_cell(y, x)
    y -= conf['y_offset']
    x -= conf['x_offset']
    @cells[x][y].alive? && @cells[x][y].dead! || @cells[x][y].alive!
  end

  def getyx
    x = []
    y = []
    @gol.getyx(y, x)
    [y.first, x.first]
  end

  def set_cursor(y, x)
    @gol.wmove(y, x)
    @gol.refresh
  end

  def key_map
    conf['key_map']
  end

  def run_logic
    @gol.timeout(1)
    logic_steps
  end

  def logic_steps
    generation_update
    @logic.step
    update_cells
    key = @gol.getch
    key != conf['key_quit'] && logic_steps
  end

  def generation_update
    @generation ||= 0
    @generation += 1
    @gol.mvwaddstr(conf['height'] + 3, 2, "Generation #{@generation}")
  end

  def display_help
    @gol.mvwaddstr(conf['height'] + 4, 2, conf['help'])
    return_origin
  end

  def return_origin
    @gol.move(conf['y_offset'], conf['x_offset'])
    @gol.refresh
  end
end
