class WildSpiritBar
  attr_reader :number_of_people_in_venue

  def initialize(capacity_percentages)
    @capacity_percentages = capacity_percentages
    # @types_of_scales = {:high, :medium, :low}
    # @types_of_units = {:beer, :cocktails_and_liquor, :wine, :non_alcoholic}
    @capacity_of_venue = 60
    # @buying_habit_percentages = {beer: 70, cocktails_and_liquor: 20, wine: 3, non_alcoholic: 7}
    @number_of_people_in_venue = calculate_number_of_people_in_venue
  end

  def calculate_number_of_people_in_venue
    low_capacity = percentage(@capacity_percentages[:low], @capacity_of_venue)
    medium_capacity = percentage(@capacity_percentages[:medium], @capacity_of_venue)
    high_capacity = percentage(@capacity_percentages[:high], @capacity_of_venue)
    {low: low_capacity, medium: medium_capacity, high: high_capacity}
  end

  def percentage(percentage, starting_value)
    (percentage*starting_value) / 100
  end

  # def calculate_units_sold
  #   @types_of_scale do |scale|
  #     @types_of_units do |units|
  #       buying_habit_percentages[scale][unit]/@number_of_people_in_venue[scale]
  #     end
  #   end
  #   # buying_habit_percentages[:high][:beer]
  #   # buying_habit_percentages[:high][:cocktails_and_liquor]
  #   # buying_habit_percentages[:high][:wine]
  #   # buying_habit_percentages[:high][:non_alcoholic]
  # end
end


def assert(e)
  if e
    puts "pass"
  else
    puts "fail"
  end
end

puts "Test Low Capacity Number of People in Bar Return"
assert(WildSpiritBar.new({low: 10, medium: 20, high: 33}).number_of_people_in_venue[:low] == 6)
puts "Test Medium Capacity Number of People in Bar Return"
assert(WildSpiritBar.new({low: 10, medium: 20, high: 33}).number_of_people_in_venue[:medium] == 12)
puts "Test High Capacity Number of People in Bar Return"
assert(WildSpiritBar.new({low: 10, medium: 20, high: 33}).number_of_people_in_venue[:high] == 19)


