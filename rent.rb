require 'sinatra'
require 'json'

get '/' do
  html = ""

  @months = {
    #'August' => {
    #  tenants: {
    #    'Alex' => 'a',
    #    'Dmitry' => 'd',
    #    'James' => 'j2',
    #    'Jimmy' => 'j1',
    #    'Jordan' => 'j3',
    #    'Mel' => 'm',
    #    'Sara' => 's'
    #  },
    #  rooms: ['a', 'd', 'j3', 'm', 'j1', 's', 'j2'],
    #  extra_roommates: {'s' => 0.5},
    #  partial_months: {'j3' => 0.25},
    #  fixed_rents: {},
    #  extra_fees: {'j1' => 30}
    #},
    #'September' => {
    #  tenants: {
    #    'Alex' => 'a',
    #    'Danielle' => 'j3',
    #    'Dmitry' => 'd',
    #    'James' => 'j2',
    #    'Jimmy' => 'j1',
    #    'Mel' => 'm',
    #    'Sara' => 's'
    #  },
    #  rooms: ['a', 'd', 'j3', 'm', 'j1', 's', 'j2'],
    #  extra_roommates: {},
    #  partial_months: {'s' => 0.2},
    #  fixed_rents: {'j3' => 660.68},
    #  extra_fees: {'j1' => 30}
    #},
    'October 2013' => {
      tenants: {
        'Alex' => 'a',
        'Danielle' => 'j3',
        'Dmitry' => 'd',
        'James' => 'j2',
        'Jimmy' => 'j1',
        'Mel' => 'm',
        'Noemie' => 's'
      },
      rooms: ['a', 'd', 'j3', 'm', 'j1', 's', 'j2'],
      extra_roommates: {},
      partial_months: {},
      fixed_rents: {'s' => 824.71},
      extra_fees: {'j1' => 30}
    },
    'November 2013' => {
      tenants: {
        'Alex' => 'a',
        'Danielle' => 'j3',
        'Dmitry' => 'd',
        'James' => 'j2',
        'Jimmy' => 'j1',
        'Mel' => 'm',
        'Noemie' => 's'
      },
      rooms: ['a', 'd', 'j3', 'm', 'j1', 's', 'j2'],
      extra_roommates: {},
      partial_months: {},
      fixed_rents: {},
      extra_fees: {'j1' => 30}
    },
    'December 2013' => {
      tenants: {
        'Alex' => 'a',
        'Danielle' => 'j3',
        'Dmitry' => 'd',
        'James' => 'j2',
        'Jimmy' => 'j1',
        'Mel' => 'm',
        'Noemie' => 's'
      },
      rooms: ['a', 'd', 'j3', 'm', 'j1', 's', 'j2'],
      extra_roommates: {},
      partial_months: {},
      fixed_rents: {},
      extra_fees: {'j1' => 30}
    },
    'January 2014' => {
      tenants: {
        'Alex' => 'a',
        'Danielle' => 'j3',
        'Dmitry' => 'd',
        'James' => 'j2',
        'Jimmy' => 'j1',
        'Mel' => 'm',
        'Asali' => 's'
      },
      rooms: ['a', 'd', 'j3', 'm', 'j1', 's', 'j2'],
      extra_roommates: {},
      partial_months: {},
      fixed_rents: {},
      extra_fees: {'j1' => 30}
    },
    'February 2014' => {
      tenants: {
        'Alex' => 'a',
        'Danielle' => 'j3',
        'Dmitry' => 'd',
        'James' => 'j2',
        'Jimmy' => 'j1',
        'Mel' => 'm',
        'Asali' => 's'
      },
      rooms: ['a', 'd', 'j3', 'm', 'j1', 's', 'j2'],
      extra_roommates: {},
      partial_months: {},
      fixed_rents: {},
      extra_fees: {'j1' => 30}
    },
    'March 2014' => {
      tenants: {
        'Alex' => 'a',
        'Danielle' => 'j3',
        'Dmitry' => 'd',
        'James' => 'j2',
        'Jimmy' => 'j1',
        'Mel' => 'm',
        'Asali' => 's'
      },
      rooms: ['a', 'd', 'j3', 'm', 'j1', 's', 'j2'],
      extra_roommates: {},
      partial_months: {},
      fixed_rents: {},
      extra_fees: {'j1' => 30}
    },
    'April 2014' => {
      tenants: {
        'Alex' => 'a',
        'Danielle' => 'j3',
        'Dmitry' => 'd',
        'James' => 'j2',
        'Jimmy' => 'j1',
        'Mel' => 'm',
        'Asali' => 's'
      },
      rooms: ['a', 'd', 'j3', 'm', 'j1', 's', 'j2'],
      extra_roommates: {},
      partial_months: {},
      fixed_rents: {},
      extra_fees: {'j1' => 30}
    },
    'May 2014' => {
      tenants: {
        'Alex' => 'a',
        'Danielle' => 'j3',
        'Dmitry' => 'd',
        'James' => 'j2',
        'Jimmy' => 'j1',
        'Mel' => 'm',
        'Asali' => 's'
      },
      rooms: ['a', 'd', 'j3', 'm', 'j1', 's', 'j2'],
      extra_roommates: {},
      partial_months: {},
      fixed_rents: {},
      extra_fees: {'j1' => 30}
    },
    'June 2014' => {
      tenants: {
        'Alex' => 'a',
        'Danielle' => 'j3',
        'Dmitry' => 'd',
        'James' => 'j2',
        'Jimmy' => 'j1',
        'Mel' => 'm',
        'Asali' => 's'
      },
      rooms: ['a', 'd', 'j3', 'm', 'j1', 's', 'j2'],
      extra_roommates: {},
      partial_months: {},
      fixed_rents: {},
      extra_fees: {'j1' => 30}
    },
    'July 2014' => {
      tenants: {
        'Alex' => 'a',
        'Danielle' => 'j3',
        'Dmitry' => 'd',
        'James' => 'j2',
        'Jimmy' => 'j1',
        'Mel' => 'm',
        'Asali' => 's'
      },
      rooms: ['a', 'd', 'j3', 'm', 'j1', 's', 'j2'],
      extra_roommates: {},
      partial_months: {},
      fixed_rents: {},
      extra_fees: {'j1' => 30}
    },
    'August 2014' => {
      tenants: {
        'Alex' => 'a',
        'Danielle' => 'j3',
        'Dmitry' => 'd',
        'James' => 'j2',
        'Jimmy+Honza' => 'j1',
        'Mel' => 'm',
        'Asali' => 's'
      },
      rooms: ['a', 'd', 'j3', 'm', 'j1', 's', 'j2'],
      extra_roommates: {},
      partial_months: {},
      fixed_rents: {},
      extra_fees: {'j1' => 30},
      split_rooms: {'Jimmy+Honza' => {
        'Jimmy' => 0.57,
        'Honza' => 0.43
      }}
    }
  }
  @last_month = @months.values.last

  @all_tenants = ['Alex','Asali','Danielle','Dmitry','Honza','James','Jimmy','Mel','Noemie']

  @months.each do |month_name, month|
    @months[month_name][:parameters] = month.reject {|k, v| k == :tenants}.to_json
    @months[month_name][:rent] = calculate_rent(month)
    @months[month_name][:tenant_names] = @all_tenants.select {|t| has_tenant(month, t)}
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

def has_tenant(month, tenant)
  if month[:tenants][tenant]
    return true
  elsif month[:split_rooms]
    month[:split_rooms].each do |name, roommates|
      if roommates.keys.any? {|r| r == tenant}
        return true
      end
    end
    return false
  end
end

def rent_by_tenant(month, tenant)
  rent = month[:rent][month[:tenants][tenant]]
  if month[:split_rooms]
    month[:split_rooms].each do |name, roommates|
      room_rent = month[:rent][month[:tenants][name]]
      roommates.each do |roommate, ratio|
        if roommate == tenant
          rent = room_rent * ratio
        end
      end
    end
  end
  rent
end

def calculate_rent(month)
  rooms = month[:rooms]
  num_rooms = rooms.count
  rooms = rooms.reject {|r| month[:fixed_rents].include? r }
  room_sizes = ROOM_SIZES.select {|k,v| rooms.include? k }

  num_tenants = rooms.count + month[:extra_roommates].count
  tenants_per_room = Hash[rooms.map {|r| [r, month[:extra_roommates].fetch(r, 0) + 1]}]

  length_of_stay = Hash[rooms.map {|r| [r, month[:partial_months][r] ? month[:partial_months][r] : 1]}]
  man_months_per_room = Hash[rooms.map {|r| [r, tenants_per_room[r] * length_of_stay[r]]}]

  total_room_size = room_sizes.map {|k, v| length_of_stay[k] * v}.inject(:+)
  total_man_months = man_months_per_room.values.inject(:+)

  total_before_normalization = STARTING_COMMON_PRICE * total_man_months +
                                PRICE_PER_SQ_FT[num_rooms] * total_room_size

  normalizer = (TOTAL_RENT - month[:fixed_rents].values.inject(0, :+)) / total_before_normalization

  rents = room_sizes.merge(month[:fixed_rents]).map do |room, size|
    if month[:fixed_rents].include? room
      month[:fixed_rents][room]
    else
      ((PRICE_PER_SQ_FT[num_rooms] * size +
        STARTING_COMMON_PRICE * tenants_per_room[room]) *
            (length_of_stay[room] * normalizer))
    end
  end

  total_rent = rents.map(&:to_f).inject(:+)
  rents_by_room = Hash[room_sizes.merge(month[:fixed_rents]).map { |k, v| k }.zip(rents)]

  if total_rent >= TOTAL_RENT - TOLERANCE && total_rent <= TOTAL_RENT + TOLERANCE
    adjustment = TOTAL_RENT - total_rent
    if adjustment > 0
      # if numbers don't quite add up, make one penny adjustment to a random room
      random_room = rents_by_room.keys.sample
      rents_by_room[random_room] += adjustment
    end
  else
    raise "Expected total to be #{TOTAL_RENT - TOLERANCE} - #{TOTAL_RENT + TOLERANCE} but got #{total_rent}"
  end

  month[:extra_fees].each do |room, fee|
    rents_by_room[room] += fee
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
# puts 'SEPTEMBER 2013: Sara moving out after 1/5 month and Danielle moving in with fixed rent:'
# puts calculate_rent [:a, :d, :j3, :m, :j1, :s, :j2], {}, {:s => 0.2}, {:j3 => 660.68}
