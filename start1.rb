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
  String  :color
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
	     :color => "#FF0000",
	     :x => Random.rand(1..5),
             :y => Random.rand(1..5)
	    )
units.insert(:name => 'lampros',
             :attack => 1,
             :defense => 1,
             :level => 1,
             :hit_points => 2,
             :speed => 2,
	     :color => "#00FFFF",
             :x => Random.rand(1..5),
             :y => Random.rand(1..5)
            )

def move_form(name,x,y)
  form='<form method="POST" action="/move">
  <input type="hidden" name="name" value="'+name+'" />
  X:<select name="x">'
  for i in 1..x
	form=form+'<option value="'+i.to_s+'">'+i.to_s+'</option>'+"\r\n"
  end
  form=form+'</select><br>'
  form=form+'Y:<select name="y">'
  for i in 1..y
	form=form+'<option value="'+i.to_s+'">'+i.to_s+'</option>'+"\r\n"
  end
  form=form+'</select>
  <input type="submit" value="Move" /></form>'
  return form
end

def draw_table_cell(dataset,table_y,table_x,height,width)
  filter = dataset.select.where(:x=>table_x, :y=>table_y)
  if filter.count==0
	 output="x:#{table_x},y:#{table_y}"
  else
	 output="<b>"
         filter.each do |i|
             output=""+output+i[:name]+"<p>"+move_form(i[:name],height,width)
         end
	 output=output+"</b>"
  end
  return output
end

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
			table = table + "<td>" + draw_table_cell(dataset,x,y,height,width).to_s + "</td>"
		end
	  table = table + "</tr>\n\r"
  end
  table = table + "</table>\n\r"
  return table
end

def move_unit(dataset,name,x,y)
  puts "move called!"
  id=dataset.select.where(:name=>name)
  id=id.first[:id]
  dataset.filter(:id=>id).update(:x=>x,:y=>y)
end

move_unit(units,"lampros",3,2)


get '/' do
	draw_table(units,5,5)	
end

post '/move' do
   name=params[:name]
   puts name
   x=params[:x] 
   puts x
   y=params[:y]
   puts y
   move_unit(units,name,x,y)
   redirect "/"
end
