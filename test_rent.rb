require_relative 'rent'

# NOTE: these tests use now-deprecated syntax
# TODO: update tests to newer syntax

puts 'TEST CASES'
puts 'Verify against Jimmy\'s numbers if you don\'t trust me:'
puts "\thttps://docs.google.com/spreadsheet/ccc?key=0AqqTjCcbT2O9dE9uWTJJLURaOXRjanNGUXJrdTcxVkE#gid=0"
puts '[Note: rooms are indexed by initial occupant (j1 = Jimmy, j2 = James, j3 = Jordan)]'
puts '6 person rent with downtairs living room:'
puts calculate_rent [:a, :d, :m, :j1, :s, :j2]
puts '7 person rent:'
puts calculate_rent [:a, :d, :j3, :m, :j1, :s, :j2]
puts '7 person rent with Sara roommate:'
puts calculate_rent [:a, :d, :j3, :m, :j1, :s, :j2], {:s => 1}
puts '1st month with Jordan (June):'
puts calculate_rent [:a, :d, :j3, :m, :j1, :s, :j2], {}, {}, {:j3 => 900}
puts '1/2 month Sara roommate with Jordan mostly moved out:'
puts calculate_rent [:a, :d, :j3, :m, :j1, :s, :j2], {:s => 0.5}, {:j3 => 0.25}
puts 'Alex dies:'
puts calculate_rent [:d, :j3, :m, :j1, :s, :j2]
puts 'SEPTEMBER 2013: Sara moving out after 1/5 month and Danielle moving in with fixed rent:'
puts calculate_rent [:a, :d, :j3, :m, :j1, :s, :j2], {}, {:s => 0.2}, {:j3 => 660.68}
