require 'rubygems'
require 'sinatra'
require 'sequel'

set :bind, '0.0.0.0'
set :port, 80

DB = Sequel.sqlite
DB.create_table :units do
  primary_key :id
  String :name
  Integer :attack
  Integer :defense
  Integer :level
  Integer :hit_points
  Integer :speed
  Integer :x
  Integer :y
end

units = DB[:units]
units.insert(:name => 'stelios', 
	     :attack => 1, 
	     :defense => 1,
	     :level => 1,
	     :hit_points => 2,
	     :speed => 2,
	     :x => Random.rand(1..20),
             :y => Random.rand(1..20)
	    )
units.insert(:name => 'lampros',
             :attack => 1,
             :defense => 1,
             :level => 1,
             :hit_points => 2,
             :speed => 2,
             :x => Random.rand(1..20),
             :y => Random.rand(1..20)
            )

	    units.each do |i|
		puts i[:name]
		puts i[:x]
		puts i[:y]
	    end


def draw_table_cell(dataset,table_y,table_x)
  output=""
	#  puts "inside function"
  filter = dataset.select.where(:x=>table_x, :y=>table_y)
  if filter.count==0
	 output="-=-"
  else
	 output="<b>"
         filter.each do |i|
             output=output+i[:name]
         end
	 output=output+"</b>"
  end
  return output
end

draw_table_cell(units, 1,1)

def draw_table(dataset,height,width)
  table = ""
  table = table + "<style>
  tr
  {
     height:75px;
  }
  td
  {
     width:75px;
  }
  </style>"
  table = table + "<center><table>\n\r"
  for y in 1..height
	  table = table + "<tr>"
		for x in 1..width
			table = table + "<td>" + draw_table_cell(dataset,x,y).to_s + "</td>"
		end
	  table = table + "</tr>\n\r"
  end
  table = table + "</table>\n\r"
  return table
end


get '/' do
	draw_table(units,20,20)	
end
