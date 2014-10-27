#assumptions
# Mon-Thurs 5pm-2am, Friday 5pm-3m, Sat 10am-3am, Sun 10am-2am
# open monthly for: 54 + 10 +  17 + 16 = 97 weekly, so 388 hours a month
# low hours = first three hours opened and last 2 hours on weekdays opened so 29 hours a week and 116 hours a month
# high hours = 2 hours on weekdays so 8  + Fri/Sat from 8 pm until 2 am so 12, plus Sunday from 7 pm to 11 pm so 3  so 23 per week so 92 hours per month
# normal = remaining, 388 - (116 + 92), 388 - 208 = 180 hrs per month

class Bar
  def initialize(percent_full_at_capacity, percentage_capacity_growth_rate, capacity_of_venue)
    @percent_full_at_capacity = percent_full_at_capacity
    @percentage_capacity_growth_rate = percentage_capacity_growth_rate/100.0
    @types_of_units = [:beer, :cocktails_and_liquor, :wine, :non_alcoholic]
    @units_sold_each_month = []
    @capacity_of_venue = capacity_of_venue
    calculate_units_sold
  end


  def units_sold_this_year(type, time_frame)
    i = 0
    type_name = type.downcase.gsub(/\s|-/, "_") + "s"
    12.times do
      month = i + 1
      p "Month #{month}: #{@units_sold_each_month[i][time_frame.to_sym][type.to_sym].round} #{type_name} sold #{time_frame}"
      i += 1
    end
  end

  private

  def calculate_units_sold
    month_index = 0
    12.times do
      people_in_venue = calculate_number_of_people_in_venue_per_capacity_level(month_index)
      units_sold_hour = calculate_types_of_units_sold_per_capacity_level_each_hour(people_in_venue)
      units_sold_week = extrapolate_units_sold_weekly(units_sold_hour)
      units_sold_month = extrapolate_units_sold_monthly(units_sold_week)
      @units_sold_each_month[month_index] = {:hourly => units_sold_hour, :weekly => units_sold_week, :monthly => units_sold_month}
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

# Tests

# bar = Bar.new({low: 10, medium: 20, high: 33}, 5, 60)

# puts "Test High Capacity Drinks Sold Month 1"
# assert(bar.units_sold_each_month[0][:hourly][:high] == {:beer=>13.86, :cocktails_and_liquor=>3.96, :wine=>0.5940000000000001, :non_alcoholic=>1.386}, "#{bar.units_sold_each_month[0][:hourly][:high]} does not equal {:beer=>13.86, :cocktails_and_liquor=>3.96, :wine=>0.5940000000000001, :non_alcoholic=>1.386}")
# puts "Test Weekly Drinks Sold Month 1"
# assert(bar.units_sold_each_month[0][:weekly][:beer].round == 939, "#{bar.units_sold_each_month[0][:weekly][:beer].round} does not equal 939")
# puts "Test Monthy Drinks Sold Month 1"
# assert(bar.units_sold_each_month[0][:monthly][:beer].round == 3755, "#{bar.units_sold_each_month[0][:monthly][:beer].round} does not equal 3755")


wild_spirit = Bar.new({low: 12, medium: 40, high: 60}, 5, 60)
wild_spirit.units_sold_this_year("beer", "weekly")
wild_spirit.units_sold_this_year("beer", "monthly")