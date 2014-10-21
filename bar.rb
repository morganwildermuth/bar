class Bar
  attr_reader :number_of_people_in_venue, :units_sold

  def initialize(percent_full_of_capacity)
    @percent_full_of_capacity = percent_full_of_capacity
    @units_sold = {}
    @capacity_of_venue = 60
    @number_of_people_in_venue = calculate_number_of_people_in_venue
    calculate_units_sold
  end

  def calculate_number_of_people_in_venue
    low_capacity = percentage(@percent_full_of_capacity[:low], @capacity_of_venue)
    medium_capacity = percentage(@percent_full_of_capacity[:medium], @capacity_of_venue)
    high_capacity = percentage(@percent_full_of_capacity[:high], @capacity_of_venue)
    {low: low_capacity, medium: medium_capacity, high: high_capacity}
  end

  def percentage(percentage, starting_value)
    (percentage*starting_value) / 100
  end

  def calculate_units_sold
    types_of_scale = [:high, :medium, :low]
    types_of_units = [:beer, :cocktails_and_liquor, :wine, :non_alcoholic]
    buying_habit_percentages = {beer: 70, cocktails_and_liquor: 20, wine: 3, non_alcoholic: 7}
    types_of_scale.each do |scale|
      @units_sold[scale] = {}
      types_of_units.each do |unit|
        p 'unit'
        p unit
        p percentage(buying_habit_percentages[unit], @number_of_people_in_venue[scale])
        p 'venue'
        p scale
        p @number_of_people_in_venue[scale]
        @units_sold[scale][unit] = percentage(buying_habit_percentages[unit], @number_of_people_in_venue[scale])
      end
    end
    p @units_sold
    # buying_habit_percentages[:high][:beer]
    # buying_habit_percentages[:high][:cocktails_and_liquor]
    # buying_habit_percentages[:high][:wine]
    # buying_habit_percentages[:high][:non_alcoholic]
  end
end


def assert(e)
  if e
    puts "pass"
  else
    puts "fail"
  end
end

puts "Test Low Capacity Number of People in Bar Return"
assert(Bar.new({low: 10, medium: 20, high: 33}).number_of_people_in_venue[:low] == 6)
puts "Test Medium Capacity Number of People in Bar Return"
assert(Bar.new({low: 10, medium: 20, high: 33}).number_of_people_in_venue[:medium] == 12)
puts "Test High Capacity Number of People in Bar Return"
assert(Bar.new({low: 10, medium: 20, high: 33}).number_of_people_in_venue[:high] == 19)
puts "Test Low Capacity Drinks Sold"
assert(Bar.new({low: 10, medium: 20, high: 33}).units_sold[:high] == {beer: 13, cocktails_and_liquor: 3, wine: 0, non_alcoholic: 1})


