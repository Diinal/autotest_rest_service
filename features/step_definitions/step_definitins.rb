Допустим(/^отправляем "(.*)" запрос по адресу "(.*)" с параметром "(.*)"$/) do |method, url, param|
  body = $REQUEST_BODY ? $REQUEST_BODY : nil
  do_request(method, url + param, body)
end

Тогда(/^получаем ответ и проверяем что код ответа равен "(.*)"$/) do |code|
  error("Ожидаемый код: #{code}, по факту: #{$RESPONSE_STATUS_CODE}") if $RESPONSE_STATUS_CODE != code.to_i
end

И(/^в теле ответа "(.*)"$/) do |type_of_response|
  response_check($RESPONSE_BODY, type_of_response)
end