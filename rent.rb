require 'sinatra'
require 'json'

get '/' do
  html = ""

  @months = {
    'August' => {
      tenants: {
        'Alex' => 'a',
        'Dmitry' => 'd',
        'James' => 'j2',
        'Jimmy' => 'j1',
        'Jordan' => 'j3',
        'Mel' => 'm',
        'Sara' => 's'
      },
      rooms: ['a', 'd', 'j3', 'm', 'j1', 's', 'j2'],
      extra_roommates: {'s' => 0.5},
      partial_months: {'j3' => 0.25},
      fixed_rents: {}
    },
    'September' => {
      tenants: {
        'Alex' => 'a',
        'Danielle' => 'j3',
        'Dmitry' => 'd',
        'James' => 'j2',
        'Jimmy' => 'j1',
        'Mel' => 'm',
        'Sara' => 's'
      },
      rooms: ['a', 'd', 'j3', 'm', 'j1', 's', 'j2'],
      extra_roommates: {},
      partial_months: {'s' => 0.2},
      fixed_rents: {'j3' => 660.68}
    }
  }
  @last_month = @months.values.last

  @all_tenants = @months.map {|k, v| v[:tenants].keys}.inject(:|).sort

  @months.each do |month_name, month|
    @months[month_name][:parameters] = month.reject {|k, v| k == :tenants}.to_json
    @months[month_name][:rent] = calculate_rent(month[:rooms], month[:extra_roommates], month[:partial_months], month[:fixed_rents])
  end

  erb :index
end

post '/calculate' do
  calculate_rent(JSON.parse(params[:rooms]), JSON.parse(params[:extra_roommates]), JSON.parse(params[:partial_months]), JSON.parse(params[:fixed_rents])).to_s
end

ROOM_SIZES = { # rooms named after initial occupant
	'a' => 205,
	'd' => 205,
  'j3' => 170,
  'm' => 166,
  'j1' => 102,
  's' => 93,
  'j2' => 82.5
}

PRICE_PER_SQ_FT = { # based on number of people
  6 => 3.18728,
  7 => 2.773
}

STARTING_COMMON_PRICE = 246.61

TOTAL_RENT = 4_200
TOLERANCE = 0.01

def calculate_rent(rooms, extra_roommates = {}, partial_months = {}, fixed_rents = {})
  num_rooms = rooms.count
  rooms = rooms.reject {|r| fixed_rents.include? r }
  room_sizes = ROOM_SIZES.select {|k,v| rooms.include? k }

  num_tenants = rooms.count + extra_roommates.count
  tenants_per_room = Hash[rooms.map {|r| [r, extra_roommates.fetch(r, 0) + 1]}]

  length_of_stay = Hash[rooms.map {|r| [r, partial_months[r] ? partial_months[r] : 1]}]
  man_months_per_room = Hash[rooms.map {|r| [r, tenants_per_room[r] * length_of_stay[r]]}]

  total_room_size = room_sizes.map {|k, v| length_of_stay[k] * v}.inject(:+)
  total_man_months = man_months_per_room.values.inject(:+)

  total_before_normalization = STARTING_COMMON_PRICE * total_man_months +
                                PRICE_PER_SQ_FT[num_rooms] * total_room_size

  normalizer = (TOTAL_RENT - fixed_rents.values.inject(0, :+)) / total_before_normalization

  rents = room_sizes.merge(fixed_rents).map do |room, size|
    rent = if fixed_rents.include? room
              fixed_rents[room]
           else
             ((PRICE_PER_SQ_FT[num_rooms] * size +
                STARTING_COMMON_PRICE * tenants_per_room[room]) *
                    (length_of_stay[room] * normalizer))
           end
    '%.2f' % rent
  end

  total_rent = rents.map(&:to_f).inject(:+)
  rents_by_room = Hash[room_sizes.merge(fixed_rents).map { |k, v| k }.zip(rents)]

  if total_rent >= TOTAL_RENT - TOLERANCE && total_rent <= TOTAL_RENT + TOLERANCE
    # potentially make one penny adjustment to :j3 (or :a, if :j3 is unoccupied)
    adjustment = TOTAL_RENT - total_rent
    if rents_by_room.include? 'j3'
      rents_by_room['j3'] = '%.2f' % (rents_by_room['j3'].to_f + adjustment)
    else
      rents_by_room['a'] = '%.2f' % (rents_by_room['a'].to_f + adjustment)
    end
  else
    raise "Expected total to be #{TOTAL_RENT - TOLERANCE} - #{TOTAL_RENT + TOLERANCE} but got #{total_rent}"
  end

  rents_by_room
end

# puts 'TEST CASES'
# puts 'Verify against Jimmy\'s numbers if you don\'t trust me:'
# puts "\thttps://docs.google.com/spreadsheet/ccc?key=0AqqTjCcbT2O9dE9uWTJJLURaOXRjanNGUXJrdTcxVkE#gid=0"
# puts '[Note: rooms are indexed by initial occupant (j1 = Jimmy, j2 = James, j3 = Jordan)]'
# puts '6 person rent with downtairs living room:'
# puts calculate_rent [:a, :d, :m, :j1, :s, :j2]
# puts '7 person rent:'
# puts calculate_rent [:a, :d, :j3, :m, :j1, :s, :j2]
# puts '7 person rent with Sara roommate:'
# puts calculate_rent [:a, :d, :j3, :m, :j1, :s, :j2], {:s => 1}
# puts '1st month with Jordan (June):'
# puts calculate_rent [:a, :d, :j3, :m, :j1, :s, :j2], {}, {}, {:j3 => 900}
# puts '1/2 month Sara roommate with Jordan mostly moved out:'
# puts calculate_rent [:a, :d, :j3, :m, :j1, :s, :j2], {:s => 0.5}, {:j3 => 0.25}
# puts 'Alex dies:'
# puts calculate_rent [:d, :j3, :m, :j1, :s, :j2]
# puts 'SEPTEMBER: Sara moving out after 1/5 month and Danielle moving in with fixed rent:'
# puts calculate_rent [:a, :d, :j3, :m, :j1, :s, :j2], {}, {:s => 0.2}, {:j3 => 660.68}
