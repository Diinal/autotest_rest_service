
require './features/support/logs.rb'
require 'httparty'
require 'json'
require 'json-compare'
require 'uri'
require 'selenium-webdriver'
require 'zip'
require 'pg'

if ARGV.include?('Jenkins=true')
  $DbLogEnable  = ENV['DbLogEnable']
  $JenkinsRun   = true
else
  $DbLogEnable  = false
  $JenkinsRun   = false
end

def error(message)
  raise(message)
end

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
    file_path = './screenshot.png'
    # $driver.save_screenshot(file_path)

    # image = open(file_path, 'rb', &:read)
    # # encoded_image = Base64.encode64(image)
    # # embed(encoded_image, 'image/png;base64', 'SCREENSHOT')
    # embed(image, 'image/png', 'SCREENSHOT')
    # encoded_img = $driver.screenshot_as(:base64)
    # embed("data:image/png;base64,#{encoded_img}",'image/png')
    png = $driver.screenshot_as(:png)
    path = (0..16).to_a.map{|a| rand(16).to_s(16)}.join + '.png' # Or use some GUID library to make a unique filename - scenario names are not  guaranteed to be unique.
    File.open(path, 'wb') {|io| io.write(png)}
    embed(path, 'image/png')
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

def db_log(scenario_name, step_name, result, error=nil)
  error = "null" if not error
  begin
    con = PG.connect(:dbname => 'AutotestPetService', :user => 'autotest', :password => 'poxyi')

    sqlQuery = "INSERT INTO \"AutotestLog\" (\"ID\", \"LOGTIME\", \"SCENARIO_NAME\", \"STEP_NAME\", \"STEP_RESULT\", \"ERROR\") 
    VALUES (default, current_timestamp, '#{scenario_name}', '#{step_name}', '#{result}', '#{error}');"
    con.exec(sqlQuery)

  rescue => e
    log(e.message)
  ensure
    con.close if con
  end

  a = 0
end

if $DbLogEnable == nil
  $DbLogEnable = true
else
  $DbLogEnable = if $DbLogEnable.to_s.casecmp?('true')
                  true
                else
                  if $DbLogEnable.to_s.casecmp?('false')
                    false
                  else
                    error("Недопустимое значение DbLogEnable #{$DbLogEnable}")
                  end
                end
end