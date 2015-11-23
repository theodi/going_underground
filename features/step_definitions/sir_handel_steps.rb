And /^I do not authenticate$/ do

end

Given /^I have the following signals$/ do |string|
  allow(Blocktrain::Lookups.instance).to receive(:aliases) { YAML.load(string) }
end

Given /^I have the following Cromulent Dates$/ do |json|
  allow_any_instance_of(Redis).to receive(:get) {
    json
  }
end

Given /^I have no Cromulent Dates$/ do
  allow_any_instance_of(Redis).to receive(:get) {
    nil
  }
end
