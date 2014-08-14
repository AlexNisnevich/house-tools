require 'sinatra'
require 'json'
require 'yaml'

class Month
  attr_reader :name, :parameters, :rent

  def initialize(name, params, globals)
    @name = name
    @parameters = params
    @globals = globals

    @tenants = params['tenants']
    @extra_roommates = params['extra_roommates'] || {}
    @partial_months = params['partial_months'] || {}
    @fixed_rents = params['fixed_rents'] || {}
    @extra_fees = params['extra_fees'] || {}
    @split_months = params['split_months'] || {}

    @rent = calculate_rent
  end

  def has_tenant(tenant)
    if @tenants[tenant]
      return true
    else
      @split_months.each do |name, roommates|
        if roommates.keys.any? {|r| r == tenant}
          return true
        end
      end
      return false
    end
  end

  def rent_by_tenant(tenant)
    rent = @rent[@tenants[tenant]]
    @split_months.each do |name, roommates|
      room_rent = @rent[@tenants[name]]
      roommates.each do |roommate, ratio|
        if roommate == tenant
          rent = room_rent * ratio
        end
      end
    end
    rent
  end

  def tenants
    @globals['tenants'].select {|t| has_tenant(t)}
  end

  private

  def calculate_rent
    rooms = @tenants.values
    num_rooms = rooms.count
    rooms = rooms.reject {|r| @fixed_rents.include? r }
    room_sizes = @globals['room_sizes'].select {|k,v| rooms.include? k }

    num_tenants = rooms.count + @extra_roommates.count
    tenants_per_room = Hash[rooms.map {|r| [r, @extra_roommates.fetch(r, 0) + 1]}]

    length_of_stay = Hash[rooms.map {|r| [r, @partial_months[r] ? @partial_months[r] : 1]}]
    man_months_per_room = Hash[rooms.map {|r| [r, tenants_per_room[r] * length_of_stay[r]]}]

    total_room_size = room_sizes.map {|k, v| length_of_stay[k] * v}.inject(:+)
    total_man_months = man_months_per_room.values.inject(:+)

    total_before_normalization = @globals['starting_common_price'] * total_man_months +
                                  @globals['price_per_sq_ft'][num_rooms] * total_room_size

    normalizer = (@globals['total_rent'] - @fixed_rents.values.inject(0, :+)) / total_before_normalization

    rents = room_sizes.merge(@fixed_rents).map do |room, size|
      if @fixed_rents.include? room
        @fixed_rents[room]
      else
        ((@globals['price_per_sq_ft'][num_rooms] * size +
          @globals['starting_common_price'] * tenants_per_room[room]) *
              (length_of_stay[room] * normalizer))
      end
    end

    total_rent = rents.map(&:to_f).inject(:+)
    rents_by_room = Hash[room_sizes.merge(@fixed_rents).map { |k, v| k }.zip(rents)]

    if total_rent >= @globals['total_rent'] - @globals['tolerance'] && total_rent <= @globals['total_rent'] + @globals['tolerance']
      adjustment = @globals['total_rent'] - total_rent
      if adjustment > 0
        # if numbers don't quite add up, make one penny adjustment to a random room
        random_room = rents_by_room.keys.sample
        rents_by_room[random_room] += adjustment
      end
    else
      raise "Expected total to be #{@globals['total_rent'] - @globals['tolerance']} - #{@globals['total_rent'] + @globals['tolerance']} but got #{total_rent}"
    end

    @extra_fees.each do |room, fee|
      rents_by_room[room] += fee
    end

    rents_by_room
  end
end

data = YAML.load(open('data.yml'))
globals = data['globals']

get '/' do
  html = ""

  @months = data['months'].map {|name, params| Month.new(name, params, globals) }.reverse
  @all_tenants = globals['tenants']

  erb :index
end

post '/calculate' do
  month = Month.new('', JSON.parse(params[:params]), globals)
  'Rent by room: ' + month.rent.to_s
end
