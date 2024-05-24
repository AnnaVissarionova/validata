require_relative '../lib/validata/email_validation'
require_relative '../lib/validata/phone_number_validation'
require_relative '../lib/validata/uri_validation'
require_relative '../lib/validata/custom_validators/email_validator'
require_relative '../lib/validata/custom_validators/phone_number_validator'
require_relative '../lib/validata/custom_validators/password_validator'




puts "~~~~~~~~~~~~~ Email Validation ~~~~~~~~~~~~~"
emails = [
  "test@example.com",
  "my5email@mail.ru",
  "invalid-email",
  "validname7@but_self_made_domain.arm",
]
emails.each do |email|
  puts "#{email}: #{Validata::EmailValidation.valid?(email)}"
  puts "Comment: #{Validata::EmailValidation.validation_comment(email)}"
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
  puts "Comment: #{Validata::PhoneNumberValidation.validation_comment(num)}"
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
  puts "Comment: #{Validata::URIValidation.validation_comment(url)}"

end
puts ''
puts "~~~~~~~~~~~~~ Custom Validation ~~~~~~~~~~~~~"
email_validator = Validata::CustomValidators::EmailValidator.new(
  :email_format,
  max_length: 20,
  min_length: 10,
  allowed_domains: ['valid.com', 'example.com'],
  blocked_domains: ['blocked.com'],
)


emails = [
  'test@valid.com',
  'test@blocked.com',
  'test@example.com',
  'invalid_email',
  'too_short@ex.co',
  'long_email_address@valid.com',
  'invalid@no-mx-domain.com'
]

emails.each do |email|
  result = email_validator.valid?(email)
  puts "#{email}: #{result ? 'valid' : 'invalid'}"
end
puts ''

phone_validator = Validata::CustomValidators::PhoneNumberValidator.new(:phone_format, patterns: [/\A\+\d{1,4}\(\d{2,3}\)\d{6,9}\z/])

phone_validator.allow_country_code('1')
phone_validator.allow_country_code('44')
phone_validator.block_country_code('999')

phone_validator.allow_region('(800)')
phone_validator.block_region('(666)')


numbers = [
  '+1(800)5551234',
  '+18006665555',
  '+1(800)12341234',
  '+999(1234)5678',
  '+44(1234)567890',
  '+441234123456',
  '+6(666)012346789'
]

numbers.each do |number|
  result = phone_validator.valid?(number)
  puts "#{number}: #{result ? 'valid' : 'invalid'}"
end
puts ''

password_validator = Validata::CustomValidators::PasswordValidator.new(:default_password,
  min_length: 8, max_length: 16, require_uppercase: true, require_digit: true, blocked_chars: %w(x y z))

passwords = [
  'Password123!',
  'short',
  'alllowercase',
  'ALLUPPERCASE',
  'NoDigits!',
  'NoSpecials123',
  'Valid123!'
]

passwords.each do |password|
  result = password_validator.valid?(password)
  puts "#{password}: #{result ? 'valid' : 'invalid'}"
end
