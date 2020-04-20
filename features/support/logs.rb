def log(message)
  if $JenkinsRun
    system("echo.")
    message.split("\n").each do |line|
      system("echo #{line}")
    end
  else
    puts(message)
  end
end

def error(message)
  raise(message)
end

def db_log(scenario_name, step_name, result, error=nil)
  # error = "null" if not error
  error = (error.nil? ? "null" : "'#{error}'")
  begin
    con = PG.connect(:dbname => 'AutotestPetService', :user => 'autotest', :password => 'poxyi')

    sqlQuery = "INSERT INTO \"AutotestLog\" (\"ID\", \"LOGTIME\", \"SCENARIO_NAME\", \"STEP_NAME\", \"STEP_RESULT\", \"ERROR\") 
    VALUES (default, current_timestamp, '#{scenario_name}', '#{step_name}', '#{result}', #{error});"
    con.exec(sqlQuery)

  rescue => e
    log(e.message)
  ensure
    con.close if con
  end
end