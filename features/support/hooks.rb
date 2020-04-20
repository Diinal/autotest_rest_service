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
  error = scenario.exception
  step_name = ($scenario.test_steps[$step_num].source[4] ? $scenario.test_steps[$step_num].source[4].text : $scenario.test_steps[$step_num].source[2].text)
  db_log($scenario_name, step_name, "failed", error.to_s) if error and $DbLogEnable
  if error and $driver
    png = $driver.screenshot_as(:png)
    path = (0..16).to_a.map{|a| rand(16).to_s(16)}.join + '.png'
    File.open(path, 'wb') {|io| io.write(png)}
    embed(path, 'image/png')
  end
  $driver.quit if $driver
end

AfterStep do |_result, step|
  $step_num = ($step_num + 2) % $scenario.test_steps.length
  step_name = step.text
  db_log($scenario_name, step_name, "passed") if $DbLogEnable
end