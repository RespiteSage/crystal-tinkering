require "csv"
require "file"

io = STDIN

if ARGV.size > 0
  filename = ARGV.first

  io = File.open filename
end

csv = CSV.new io.gets_to_end, headers: true

headers = csv.headers

column_widths = Hash(String, Int32).new

headers.each { |column_header| column_widths[column_header] = column_header.size }

csv.each do |row|
  headers.each do |column_header|
    row_column_width = row[column_header].size
    column_widths.update(column_header) { |existing_value| {existing_value, row_column_width}.max }
  end
end

csv.rewind

puts "| #{headers.map { |column_header| column_header.ljust(column_widths[column_header]) }.join " | "} | "
puts "| #{headers.map { |column_header| "-" * column_widths[column_header] }.join " | "} | "

csv.each do |row|
  puts "| #{headers.map { |column_header| row[column_header].ljust(column_widths[column_header]) }.join " | "} | "
end
