require_relative '../lib/validata/email_validation'
require_relative '../lib/validata/phone_number_validation'
require_relative '../lib/validata/uri_validation'



puts "~~~~~~~~~~~~~ Email Validation ~~~~~~~~~~~~~"
emails = [
  "test@example.com",
  "my5email@mail.ru",
  "invalid-email",
  "validname7@but_self_made_domain.arm",
]
emails.each do |email|
  puts "#{email}: #{Validata::EmailValidation.valid?(email)}"
end
puts ""

puts "~~~~~~~~~~~~~ Phone Number Validation ~~~~~~~~~~~~~"
phone_nums = [
  "+79058405471",
  "+380731234567",
  "+9991234567890",
  "+380 73 1234568",
  "+1(123)4567890",
  "invalid",
  "+1234567890543567876543"
]
phone_nums.each do |num|
  puts "#{num}: #{Validata::PhoneNumberValidation.valid?(num)}"
end
puts ""


puts "~~~~~~~~~~~~~ URL Validation ~~~~~~~~~~~~~"
urls = [
  "https://www.example.com",
  "http://example.com",
  "ftp://example.com",
  "ftps://example.com",
  "http://nonexistentdomain.abc",
  "http://example",
  "ftp://example.com/path?query=value#fragment",
  "invalid://example.com"
]

urls.each do |url|
  puts "#{url}: #{Validata::URIValidation.valid?(url)}"
end
