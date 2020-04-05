
# require 'httparty'
# require 'json'

# $RESPONSE_BODY = nil
# $RESPONSE_STATUS_CODE = nil

# def error(message)
#   raise(message)
# end

# def get_request(url)
#   response = HTTParty.get(url)
#   $RESPONSE_STATUS_CODE = response.code
#   $RESPONSE_BODY = response.body
# end

# def json_check(json_file)
#   # json_file = "fvn , lv, JVNCvdnvjnvvjnf"
#   begin
#     test = JSON.parse(json_file)
#   rescue => e
#     error("Невалидный JSON")
#   end
# end