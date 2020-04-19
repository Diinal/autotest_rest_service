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