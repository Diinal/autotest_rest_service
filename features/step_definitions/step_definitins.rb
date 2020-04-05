
# Допустим(/тестим/) do
#   reg_a = /прев/
#   enc = reg_a.encoding()
#   raise("error")
# end


When("test") do
  # reg_a = /прев/
  # enc = reg_a.encoding()
  raise
end

# Допустим(/^отправляем запрос по адресу "(.*)" с параметром "(.*)"$/) do |url, param|
#   get_request(url + param)
# end

# Тогда(/^получаем ответ и проверяем что код ответа равен "(.*)"$/) do |code|
#   code = 100
#   raise("ошибка!")
#   error("Ожидаемый код: #{code}, по факту: #{$RESPONSE_STATUS_CODE}") if $RESPONSE_STATUS_CODE != code.to_i
# end

# И(/^в теле ответа "(.*)"$/) do |type_of_response|
#   json_check($RESPONSE_BODY)
# end