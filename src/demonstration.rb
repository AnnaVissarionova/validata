require_relative '../lib/validata/email_validation'
require_relative '../lib/validata/phone_number_validation'


puts "~~~~~~~~~~~~~ Email Validation ~~~~~~~~~~~~~"
puts "test@example.com: #{Validata::EmailValidation.valid?("test@example.com")}"
puts "my5email@mail.ru: #{Validata::EmailValidation.valid?("my5email@mail.ru")}"
puts "invalid-email: #{Validata::EmailValidation.valid?("invalid-email")}"
puts "validname7@but_self_made_domain.arm: #{Validata::EmailValidation.valid?("validname7@but_self_made_domain.arm")}"
puts ""

puts "~~~~~~~~~~~~~ Phone Number Validation ~~~~~~~~~~~~~"
puts "+79058405471: #{Validata::PhoneNumberValidation.valid?("+79058405471")}"
puts "+380731234567: #{Validata::PhoneNumberValidation.valid?("+380731234567")}"
puts "+9991234567890: #{Validata::PhoneNumberValidation.valid?("+9991234567890")}"
puts "+380 73 1234568: #{Validata::PhoneNumberValidation.valid?("+380 73 1234568")}"
puts "+1(123)4567890: #{Validata::PhoneNumberValidation.valid?("+1(123)4567890")}"
puts "invalid: #{Validata::PhoneNumberValidation.valid?("invalid")}"
puts "+1234567890543567876543: #{Validata::PhoneNumberValidation.valid?("+1234567890543567876543")}"
