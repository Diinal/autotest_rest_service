
require 'httparty'
require 'json'

$RESPONSE_BODY = nil
$RESPONSE_STATUS_CODE = nil

def error(message)
  raise(message)
end

def do_request(method, url, body=nil)
  if method == "GET"
    response = HTTParty.get(url)
  elsif method == "POST"
    response = HTTParty.post(url)
  end
  $RESPONSE_STATUS_CODE = response.code
  $RESPONSE_BODY = response.body
end

def response_check(response, type_of_response)
  if type_of_response == 'valid_json'
    begin
      test = JSON.parse(response)
    rescue => e
      error("Невалидный JSON.")
    end
  elsif type_of_response == 'none'
    error("Ошибка! Ответ должен быть пустым.") if response != ''
  else
    error("Неверный параметр для проверки ответа.")
  end
end