Before do 
  $RESPONSE_BODY = nil
  $RESPONSE_STATUS_CODE = nil
  $PET = nil
  $PET_ID = nil
  $ORDER = nil
  $ORDER_ID = nil
  $driver = nil
end

After do |scenario|
  $driver.quit if $driver
end