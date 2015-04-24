class Cell
  attr_accessor :status

  def initialize
    @status = 0
  end

  def dead!
    self.status = 0
  end

  def alive!
    self.status = 1
  end
end
