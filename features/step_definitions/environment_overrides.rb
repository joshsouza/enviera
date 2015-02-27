Given /^my (.*) is set to \"(.*?)\"$/ do |key, value|
  ENV[key] = value
end
Given /^my (.*) contains \"(.*?)\"$/ do |key, path_value|
  return if ENV[key].start_with? path_value
  paths = [path_value] + ENV[key].split(File::PATH_SEPARATOR)
  ENV[key] = paths.join(File::PATH_SEPARATOR)
end