require 'rubygems'
require 'sinatra'

set :bind, '0.0.0.0'
set :port, 80

def draw_table(height,width)
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
			table = table + "<td>" + "#{y},#{x}" + "</td>"
		end
	  table = table + "</tr>\n\r"
  end
  table = table + "</table>\n\r"
  return table
end


get '/' do
	draw_table(9,9)	
end
