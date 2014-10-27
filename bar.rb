#assumptions
# Mon-Thurs 5pm-2am, Friday 5pm-3m, Sat 10am-3am, Sun 10am-2am
# open monthly for: 54 + 10 +  17 + 16 = 97 weekly, so 388 hours a month
# low hours = first three hours opened and last 2 hours on weekdays opened so 29 hours a week and 116 hours a month
# high hours = 2 hours on weekdays so 8  + Fri/Sat from 8 pm until 2 am so 12, plus Sunday from 7 pm to 11 pm so 3  so 23 per week so 92 hours per month
# normal = remaining, 388 - (116 + 92), 388 - 208 = 180 hrs per month

class UnitsSoldPresenter
  def initialize(units_sold_object)
    @units_sold_object = units_sold_object
  end

  def units_sold(type, time_frame, iterations)
    i = 0
    type_name = type.downcase.gsub(/\s|-/, "_") + "s"
    iterations.times do
      month = i + 1
      p "Month #{month}: #{@units_sold_object.month[i][time_frame.to_sym][type.to_sym].round} #{type_name} sold #{time_frame}"
      i += 1
    end
  end

end

class UnitsSold
  attr_reader :month
  def initialize(percent_full_at_capacity, percentage_capacity_growth_rate, capacity_of_venue, time_increment)
    @time_increment = time_increment
    @percent_full_at_capacity = percent_full_at_capacity
    @percentage_capacity_growth_rate = percentage_capacity_growth_rate/100.0
    @types_of_units = [:beer, :cocktails_and_liquor, :wine, :non_alcoholic]
    @month = []
    @capacity_of_venue = capacity_of_venue
    calculate_units_sold
  end

  private

  def calculate_units_sold
    month_index = 0
    @time_increment.times do
      people_in_venue = calculate_number_of_people_in_venue_per_capacity_level(month_index)
      units_sold_hour = calculate_types_of_units_sold_per_capacity_level_each_hour(people_in_venue)
      units_sold_week = extrapolate_units_sold_weekly(units_sold_hour)
      units_sold_month = extrapolate_units_sold_monthly(units_sold_week)
      @month[month_index] = {:hourly => units_sold_hour, :weekly => units_sold_week, :monthly => units_sold_month}
      month_index += 1
    end
  end

  def calculate_number_of_people_in_venue_per_capacity_level(month_index)
    percent_full_at_capacity = @percent_full_at_capacity.dup.inject({}) do |hash, (key, value)|
      if month_index != 0

        # FV = PV(1 + i)^t
        present_value = @percent_full_at_capacity[key]
        present_value_plus_percent_addition = (1 + @percentage_capacity_growth_rate)
        exponent_time_variable = month_index + 1

        value = present_value * present_value_plus_percent_addition ** exponent_time_variable
        value = lower_capacity_level_if_above_max(value, key)

        hash[key] = value
      else
        value = @percent_full_at_capacity[key]
        hash[key] = value
      end
      hash
    end
    low_capacity = percentage(percent_full_at_capacity[:low], @capacity_of_venue)
    medium_capacity = percentage(percent_full_at_capacity[:medium], @capacity_of_venue)
    high_capacity = percentage(percent_full_at_capacity[:high], @capacity_of_venue)
    {low: low_capacity, medium: medium_capacity, high: high_capacity}
  end

  def lower_capacity_level_if_above_max(value, key)
    case key
    when :low
      value = 30 if value > 30
    when :medium
      value = 60 if value > 60
    when :high
      value = 90 if value > 90
    end
    value
  end

  def percentage(percentage, starting_value)
    (percentage*starting_value) / 100.0
  end

  def calculate_types_of_units_sold_per_capacity_level_each_hour(number_of_people_in_venue_per_capacity_level)
    types_of_units_sold_per_capacity_level_each_hour = {}
    types_of_scale = [:high, :medium, :low]
    buying_habit_percentages = {beer: 70, cocktails_and_liquor: 20, wine: 3, non_alcoholic: 7}
    types_of_scale.each do |scale|
      types_of_units_sold_per_capacity_level_each_hour[scale] = {}
      @types_of_units.each do |unit|
        types_of_units_sold_per_capacity_level_each_hour[scale][unit] = percentage(buying_habit_percentages[unit], number_of_people_in_venue_per_capacity_level[scale])
      end
    end
    types_of_units_sold_per_capacity_level_each_hour
  end

  def extrapolate_units_sold_weekly(units_sold_hour)
    units_sold_week = {}
    weekly_hours_open = {low: 29, medium: 23, high: 45}
    @types_of_units.each do |unit|
      units_sold_on_low_hours = units_sold_hour[:low][unit] * weekly_hours_open[:low]
      units_sold_on_med_hours = units_sold_hour[:medium][unit] * weekly_hours_open[:medium]
      units_sold_on_high_hours = units_sold_hour[:high][unit] * weekly_hours_open[:high]
      units_sold_week[unit] = units_sold_on_low_hours + units_sold_on_med_hours + units_sold_on_high_hours
    end
    units_sold_week
  end

  def extrapolate_units_sold_monthly(units_sold_week)
    units_sold_month = {}
    units_sold_month = units_sold_week.dup.inject({}) do |hash, (k, v)|
      hash[k] = v * 4; hash
    end
    units_sold_month
  end
end

def assert(e, phrase)
  if e
    puts "pass"
  else
    puts phrase
  end
end

def run_program
  unit_type = ARGV[0]
  time_type = ARGV[1]
  time_increment = ARGV[2].to_i
  units_sold = UnitsSold.new({low: 1, medium: 5, high: 10}, 5, 60, time_increment)
  presenter = UnitsSoldPresenter.new(units_sold)
  presenter.units_sold(unit_type, time_type, time_increment)
end
# Tests

# units_sold = UnitsSold.new({low: 10, medium: 20, high: 33}, 5, 60)
# units_sold_presenter = UnitsSoldPresenter.new(units_sold)

# puts "Test High Capacity Drinks Sold Month 1"
# assert(units_sold.month[0][:hourly][:high] == {:beer=>13.86, :cocktails_and_liquor=>3.96, :wine=>0.5940000000000001, :non_alcoholic=>1.386}, "#{units_sold.month[0][:hourly][:high]} does not equal {:beer=>13.86, :cocktails_and_liquor=>3.96, :wine=>0.5940000000000001, :non_alcoholic=>1.386}")
# puts "Test Weekly Drinks Sold Month 1"
# assert(units_sold.month[0][:weekly][:beer].round == 939, "#{units_sold.month[0][:weekly][:beer].round} does not equal 939")
# puts "Test Monthy Drinks Sold Month 1"
# assert(units_sold.month[0][:monthly][:beer].round == 3755, "#{units_sold.month[0][:monthly][:beer].round} does not equal 3755")

# units_sold_two = UnitsSold.new({low: 30, medium: 60, high: 90}, 5, 60)
# units_sold_presenter_two = UnitsSoldPresenter.new(units_sold_two)
# puts "Test capacities stay constant at low 30, medium 60, and high 90"
# assert((units_sold_presenter.units_sold("beer", "monthly", 1) + units_sold_presenter.units_sold("beer", "monthly", 1)) == units_sold_presenter.units_sold("beer", "monthly", 2), "Max capacities are not being implemented")


# EX
# ruby bar.rb beer weekly 10
# ruby bar.rb beer monthly 12
# ruby bar.rb wine monthly 12
# ruby bar.rb cocktails_and_liquor monthly 12


run_program
