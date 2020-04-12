Допустим(/^отправляем "(.*)" запрос по адресу "(.*)" с параметром "(.*)"$/) do |method, url, param|
  param = eval(param.gsub("%", "")).to_s if param.include?("%")
  body = $REQUEST_BODY ? $REQUEST_BODY : nil
  do_request(method, url + param, body)
end

Тогда(/^получаем ответ и проверяем что код ответа равен "(.*)"$/) do |code|
  error("Ожидаемый код: #{code}, по факту: #{$RESPONSE_STATUS_CODE}") if $RESPONSE_STATUS_CODE != code.to_i
end

И(/^в теле ответа "(.*)"$/) do |type_of_response|
  response_check($RESPONSE_BODY, type_of_response)
end

Допустим(/^создали новое животное со статусом "(.*)"$/) do |status|
  $PET = create_json("pet", status)
  $REQUEST_BODY = $PET
end

И(/^в ответе пришло созданное животное$/) do
  created_pet = JSON.parse($PET)
  response_pet = JSON.parse($RESPONSE_BODY)

  $PET_ID = response_pet['id']
  created_pet['id'] = $PET_ID

  compare_json(created_pet, response_pet)
end

Допустим(/^создали новый заказ$/) do 
  $ORDER = create_json("order")
  $REQUEST_BODY = $ORDER
end

И(/^в ответе пришел созданный заказ$/) do
  created_order = JSON.parse($ORDER)
  response_order = JSON.parse($RESPONSE_BODY)

  $ORDER_ID = response_order['id']

  compare_json(created_order, response_order)
end