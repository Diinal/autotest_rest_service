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

Допустим(/^обновили данные по животному$/) do
  $REQUEST_BODY = update_pet()
end

И(/^в ответе пришло .* животное$/) do
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

Допустим(/^открыли браузер Google Chrome$/) do
  unzip_chrome()
  Selenium::WebDriver::Chrome.path = "./GoogleChromePortable/App/Chrome-bin/chrome.exe"
  Selenium::WebDriver::Chrome::Service.driver_path = "./GoogleChromePortable/chromedriver.exe"

  $driver = Selenium::WebDriver.for :chrome

  $driver.manage.window.maximize
  $driver.manage.timeouts.implicit_wait = 10
end

И(/^перешли по адресу "(.*)"$/) do |url|
  $driver.navigate.to(url)
end

И(/^проверили доступность элемента "(.*)"$/) do |element_name|
  if element_name == "поиск"
    path = {xpath: "//div[@class='search2__button']/button"}
    check_element(path)
  else
    error("Unknown element #{element_name}")
  end
end