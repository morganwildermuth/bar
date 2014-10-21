#assumptions
# open monthly for: 54 + 10 +  17 + 16 = 97 weekly, so 388 hours a month
# low hours = first three hours opened and last 2 hours on weekdays opened so 29 hours a week and 116 hours a month
# high hours = 2 hours on weekdays so 8  + Fri/Sat from 8 pm until 2 am so 12, plus Sunday from 7 pm to 11 pm so 3  so 23 per week so 92 hours per month
# normal = remaining, 388 - (116 + 92), 388 - 208 = 180 hrs per month

class Bar
  attr_reader :number_of_people_in_venue, :units_sold_hourly, :units_sold_weekly, :units_sold_monthly

  def initialize(percent_full_of_capacity)
    @percent_full_of_capacity = percent_full_of_capacity
    @types_of_units = [:beer, :cocktails_and_liquor, :wine, :non_alcoholic]
    @units_sold_hourly = {}
    @units_sold_weekly = {}
    @units_sold_monthly = {}
    @capacity_of_venue = 60
    @number_of_people_in_venue = calculate_number_of_people_in_venue
    calculate_units_sold_hourly
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

  def calculate_units_sold_hourly
    types_of_scale = [:high, :medium, :low]
    buying_habit_percentages = {beer: 70, cocktails_and_liquor: 20, wine: 3, non_alcoholic: 7}
    types_of_scale.each do |scale|
      @units_sold_hourly[scale] = {}
      @types_of_units.each do |unit|
        @units_sold_hourly[scale][unit] = percentage(buying_habit_percentages[unit], @number_of_people_in_venue[scale])
      end
    end
    extrapolate_units_sold
  end

  def extrapolate_units_sold_weekly
    weekly_sales = {low: 29, medium: 23, high: 45}
    @types_of_units.each do |unit|
      @units_sold_weekly[unit] =
    end
    @units_sold_weekly = {beer:, cocktails_and_liquor:, non_alcoholic:, wine:}
  end

  def extrapolate_units_sold_monthly
  end
end

def assert(e)
  if e
    puts "pass"
  else
    puts "fail"
  end
end

# Tests

puts "Test High Capacity Number of People in Bar Return"
assert(Bar.new({low: 10, medium: 20, high: 33}).number_of_people_in_venue[:high] == 19)
puts "Test High Capacity Drinks Sold"
assert(Bar.new({low: 10, medium: 20, high: 33}).units_sold_hourly[:high] == {beer: 13, cocktails_and_liquor: 3, wine: 0, non_alcoholic: 1})
puts "Test Weekly Drinks Sold"
assert(Bar.new({low: 10, medium: 20, high: 33}).units_sold_weekly == {beer: 13, cocktails_and_liquor: 3, wine: 0, non_alcoholic: 1})
# puts "Test Monthy Drinks Sold"
# assert(Bar.new({low: 10, medium: 20, high: 33}).units_sold_monthly == {beer: 13, cocktails_and_liquor: 3, wine: 0, non_alcoholic: 1})


