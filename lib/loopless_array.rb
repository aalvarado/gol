require 'forwardable'

class LooplessArray
  extend Forwardable

  def_delegators :@list, :<<, :size

  def initialize(list = [])
    @list = list
    @index = 0
  end

  def recurse_each &block
    do_recurse_each(&block)
    reset_index_on_last
    @list
  end

  private

  def do_recurse_each &block
    block.call(current_element)
    inc_index
    index_within_bounds? && do_recurse_each(&block)
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

  def reset_index_on_last
    !index_within_bounds? && @index = 0
  end
end
