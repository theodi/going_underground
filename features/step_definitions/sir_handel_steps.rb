And(/^I do not authenticate$/) do

end

Given(/^I have the following signals$/) do |string|
  allow(Blocktrain::Lookups.instance).to receive(:aliases) { YAML.load(string) }
end
