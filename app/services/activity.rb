class Activity
  attr_accessor :data, :current_index

  def initialize(params = nil)
    @params = params
    self.data = []
    self.current_index = 0
  end
end
