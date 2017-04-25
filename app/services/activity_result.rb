class ActivityResult
  attr_reader :params
  attr_accessor :driving, :cultivating, :repairing

  WORKS = [:driving, :cultivating, :repairing]

  def initialize(params = nil)
    @params = params
    WORKS.each {|type| self.attributes[type] = Activity.new }
  end


end
