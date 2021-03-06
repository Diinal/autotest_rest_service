def do_request(method, url, body=nil)
  if method == "GET"
    response = HTTParty.get(url)
  elsif method == "POST"
    if body
      if body.include?('&')
        content_type = 'application/x-www-form-urlencoded'
      else
        content_type = 'application/json'
      end
    end
    response = HTTParty.post(url, :body => body, :headers => { 'Content-Type' => content_type} )
  elsif method == "DELETE"
    response = HTTParty.delete(url, :headers => {'api_key' => Random.new.rand(10001..99999).to_s})
  end
  log("REQUEST: METHOD: #{method};\nURL: #{url}\nBODY: #{body ? body : "none"}\n")
  $RESPONSE_STATUS_CODE = response.code
  $RESPONSE_BODY = response.body
  $REQUEST_BODY = nil
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

def update_pet()
  pet = JSON.parse($PET)
  new_name = "#{Random.new.rand(10001..99999)}"
  new_status = (["available", "pending", "sold"] - [pet["status"]]).sample
  
  $PET['name'] = new_name
  $PET['status'] = new_status

  URI.encode_www_form([["name", new_name], ["status", new_status]])
end

def compare_json(first, second)
  diffs = JsonCompare.get_diff(first, second)[:update]
  error("JSON в ответе отличается от созданного.\nРазличия: #{diffs}") if diffs
end

def check_element(path)
  begin
    element = $driver.find_element(error_path)
  rescue => e
    error("Элемент не найден")
  end
end

def unzip_chrome()
  destination = "./GoogleChromePortable/App/Chrome-bin/78.0.3904.70"
  unzip_file("./GoogleChromePortable/App/Chrome-bin/78.0.3904.70/chrome_dll.zip", destination)
  unzip_file("./GoogleChromePortable/App/Chrome-bin/78.0.3904.70/chrome_child_dll.zip", destination)
end

def unzip_file (file, destination)
  Zip::File.open(file) { |zip_file|
   zip_file.each { |f|
     f_path=File.join(destination, f.name)
     FileUtils.mkdir_p(File.dirname(f_path))
     zip_file.extract(f, f_path) unless File.exist?(f_path)
   }
  }
end