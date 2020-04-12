
require 'httparty'
require 'json'
require 'json-compare'

# $RESPONSE_BODY = nil
# $RESPONSE_STATUS_CODE = nil
# $PET = nil

def error(message)
  raise(message)
end

def do_request(method, url, body=nil)
  if method == "GET"
    response = HTTParty.get(url)
  elsif method == "POST"
    response = HTTParty.post(url, :body => body, :headers => { 'Content-Type' => 'application/json'} )
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

def create_json(type, status=nil)
  if type == 'pet'
    json = JSON.parse({
      "id": 0,
      "category": {
        "id": 0,
        "name": "#{Random.new.rand(10001..99999)}"
      },
      "name": "test",
      "photoUrls": [
        "#{Random.new.rand(10001..99999)}"
      ],
      "tags": [
        {
          "id": 0,
          "name": "#{Random.new.rand(10001..99999)}"
        }
      ],
      "status": "#{status}"
    }.to_json)

  elsif type == "order"
    cur_date = Time.now.strftime("%Y-%m-%dT%H:%M:%S.%L+0000")
    json = JSON.parse({
      "id": Random.new.rand(10001..99999),
      "petId": Random.new.rand(10001..99999),
      "quantity": Random.new.rand(1..20),
      "shipDate": "#{cur_date}",
      "status": "placed",
      "complete": true
    }.to_json)

  else
    error("Wrong type of json")
  end

  JSON.dump(json)
end

def compare_json(first, second)
  diffs = JsonCompare.get_diff(first, second)[:update]
  error("JSON в ответе отличается от созданного.\nРазличия: #{diffs}") if diffs
end