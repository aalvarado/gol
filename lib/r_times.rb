module RTimes
  def rtimes(n_times, &block)
    @_rt_index = 0
    @n_times = n_times
    do_rtimes(n_times, &block)
    n_times
  end

  def do_rtimes(n_times, &block)
    yield
    @_rt_index += 1
    @_rt_index < @n_times && do_rtimes(n_times, &block)
  end
end
