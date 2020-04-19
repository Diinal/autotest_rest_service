Before do |sc|
  $step_num = 0
  $scenario = sc
  $scenario_name = $scenario.source[1].name
  $RESPONSE_BODY = nil
  $RESPONSE_STATUS_CODE = nil
  $PET = nil
  $PET_ID = nil
  $ORDER = nil
  $ORDER_ID = nil
  $driver = nil
end

After do |scenario|
  max_step_num = $scenario.test_steps.length - 1
  $step_num -= max_step_num if $step_num > max_step_num
  $driver.quit if $driver
  error = scenario.exception
  step_name = ($scenario.test_steps[$step_num].source[4] ? $scenario.test_steps[$step_num].source[4].text : $scenario.test_steps[$step_num].source[2].text)
  db_log($scenario_name, step_name, "failed", error.to_s) if error and $DbLogEnable

  a = 0
end

AfterStep do |sc|
  step_name = ($scenario.test_steps[$step_num].source[4] ? $scenario.test_steps[$step_num].source[4].text : $scenario.test_steps[$step_num].source[2].text)
  $step_num += 2
  db_log($scenario_name, step_name, "passed") if $DbLogEnable
end