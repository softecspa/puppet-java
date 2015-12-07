Facter.add("java_home") do
  fileToTest = "/etc/alternatives/java"
  if File.exist?(fileToTest)
    setcode do
      %x{readlink -f /etc/alternatives/java}.sub(/\/bin\/java/,"").chomp
    end
  end
end
