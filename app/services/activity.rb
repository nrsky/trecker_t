class Activity
  attr_accessor :name, :data, :current_index

  def initialize(name)
    self.name = name
    self.data = []
    self.current_index = 0
  end

  def to_json
    super(:only => :data)
  end

  def add_date_to
    if self.data.present?
      self.data.each do |data_element|
        data_element[:date_to] = (data_element[:date_from] + data_element[:total_time].seconds) if data_element[:date_from].present?
      end
    end
  end
end
