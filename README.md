# Validata
**Validata** - это библиотека на Ruby для проверки паролей, почты и URI на соответсвие как стандартным правилам, так и кастомным, которые можно задать самим.

## Запуск и установка:
**Перед использованием установить bundle:**
```
bundle install
```
**Запуск демонстрации всех возможных методов:**
```
ruby src/demonstration.rb
```
**Запуск тестов:**
```
bundle exec rspec
```
## Пример использования библиотеки:
**Подключение библиотеки**
```
require_relative "../lib/validata/email_validation"
require_relative "../lib/validata/phone_number_validation"
require_relative "../lib/validata/uri_validation"
require_relative "../lib/validata/custom_validators/email_validator"
require_relative "../lib/validata/custom_validators/phone_number_validator"
require_relative "../lib/validata/custom_validators/password_validator"
```
**Проверка email**
```
email = "test@example.com"
puts "#{email}: #{Validata::EmailValidation.valid?(email)}"
puts "Comment: #{Validata::EmailValidation.validation_comment(email)}"

email = "invalid-email"
puts "#{email}: #{Validata::EmailValidation.valid?(email)}"
puts "Comment: #{Validata::EmailValidation.validation_comment(email)}"
```
**Проверка номера телефона**
```
number = "+1(123)4567890"
puts "#{number}: #{Validata::PhoneNumberValidation.valid?(number)}"
puts "Comment: #{Validata::PhonenumberValidation.validation_comment(number)}"

number = "invalid"
puts "#{number}: #{Validata::PhoneNumberValidation.valid?(number)}"
puts "Comment: #{Validata::PhonenumberValidation.validation_comment(number)}"
```
**Проверка URI**
```
uri = "https://www.example.com"
puts "#{uri}: #{Validata::URIValidation.valid?(uri)}"
puts "Comment: #{Validata::URIValidation.validation_comment(uri)}"

uri = "http://nonexistentdomain.abc"
puts "#{uri}: #{Validata::URIValidation.valid?(uri)}"
puts "Comment: #{Validata::URIValidation.validation_comment(uri)}"
```

## Кастомные классы для проверки
**Проверка email**
```
email_validator = Validata::CustomValidators::EmailValidator.new(
  :email_format,
  max_length: 20,
  min_length: 10,
  allowed_domains: ["valid.com", "example.com"],
  blocked_domains: ["blocked.com"]
)

email = "test@valid.com"
result = email_validator.valid?(email)
puts "#{email}: #{result ? "valid" : "invalid"}"

email = "test@blocked.com"
result = email_validator.valid?(email)
puts "#{email}: #{result ? "valid" : "invalid"}"
```

**Проверка номера телефона**
```
phone_validator = Validata::CustomValidators::PhoneNumberValidator.new(
  :phone_format,
  patterns: [/\A\+\d{1,4}\(\d{2,3}\)\d{6,9}\z/]
)
phone_validator.block_country_code("999")
phone_validator.allow_region("(800)")

number = "+1(800)5551234"
result = phone_validator.valid?(email)
puts "#{number}: #{result ? "valid" : "invalid"}"

number = "+999(1234)5678"
result = phone_validator.valid?(email)
puts "#{number}: #{result ? "valid" : "invalid"}"
```
