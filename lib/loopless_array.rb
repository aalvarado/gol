require 'forwardable'


class LooplessArray
  extend Forwardable

  def_delegators :@list, :<<, :size, :[], :any?

  def initialize(list = [])
    @list = list
    @index = 0
  end

# Only useful for really small number of elements
# aprox < 9000 on my computer.
# See $ ulimit -a | grep stack

  def recurse_each(&block)
    init_index
    any? && do_recurse_each(&block)
    @list
  end

  def recurse_each_with_index(&block)
    init_index
    any? && do_recurse_each_with_index(&block)
    @list
  end

  def rmap(&block)
    init_index
    @new_list = self.class.new
    any? && do_rmap(&block)
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
    recurse_after_steps(__method__, &block)
  end

  def do_recurse_each_with_index(&block)
    block.call(current_element, @index)
    recurse_after_steps(__method__, &block)
  end

  def do_rmap(&block)
    block && @new_list << block.call(current_element)
    recurse_after_steps(__method__, &block)
  end

  def recurse_after_steps(method_name, &block)
    inc_index
    index_within_bounds? && send(method_name, &block )
  end

  def current_element
    @list[@index]
  end

  def init_index
    @index = 0
  end

  def inc_index
    @index += 1
  end

  def index_within_bounds?
    @index < @list.size
  end
end
