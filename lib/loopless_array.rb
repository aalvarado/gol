require 'forwardable'


class LooplessArray
  extend Forwardable

  def_delegators :@list, :<<, :size, :[]

  def initialize(list = [])
    @list = list
    @index = 0
  end

# Only useful for really small number of elements
# aprox < 9000 on my computer.
# See $ ulimit -a | grep stack

  def recurse_each &block
    @index = 0
    do_recurse_each(&block)
    @list
  end

  def rmap &block
    @index = 0
    @new_list = self.class.new
    do_rmap(&block)
    @new_list
  end

  def compact
    new_list = self.class.new
    do_recurse_each do |e|
      e != nil && new_list << e
    end
    new_list
  end

  private

  def do_recurse_each(&block)
    block.call(current_element)
    inc_index
    index_within_bounds? && do_recurse_each(&block)
  end

  def do_rmap(&block)
    block && @new_list << block.call(current_element)
    inc_index
    index_within_bounds? && do_rmap(&block)
  end

  def current_element
    @list[@index]
  end

  def inc_index
    @index += 1
  end

  def index_within_bounds?
    @index < @list.size
  end
end
