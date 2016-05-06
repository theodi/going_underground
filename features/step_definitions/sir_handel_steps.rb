And /^I do not authenticate$/ do

end

Given /^I have the following signals$/ do |string|
  allow_any_instance_of(SirHandel::App).to receive(:lookups) { YAML.load(string) }
end

Given /^I have the following Cromulent Dates$/ do |json|
  allow_any_instance_of(SirHandel::App).to receive(:cached_dates) { json }
end

Given(/^I have the following grouped signals$/) do |string|
  allow_any_instance_of(SirHandel::App).to receive(:groups) {
    YAML.load(string)
  }
end

Given /^I have no Cromulent Dates$/ do
  allow_any_instance_of(SirHandel::App).to receive(:cached_dates) { nil }
  allow_any_instance_of(Redis).to receive(:get) { nil }
end

Given /^I request CSV$/ do
  header 'Accept', 'text/csv'
end

Then /^the response should be a CSV$/ do
  expect(last_response.header['Content-Type']).to match /text\/csv/
end

And /^the CSV response should have the headers:$/ do |headers|
  expect(CSV.parse(last_response.body).first).to eq headers.split
end

And /^the CSV response should have the values:$/ do |values|
  expect(CSV.parse(last_response.body)[1..-1]).to include values.split
end

Given(/^the signal '(.+)' returns no data$/) do |signal|
  memory_address = lookups[db_signal(signal)].upcase

  allow(Blocktrain::Aggregations::AverageAggregation).to receive(:new).and_call_original
  allow(Blocktrain::Aggregations::AverageAggregation).to receive(:new).with({
    from: anything,
    to: anything,
    interval: anything,
    memory_addresses: memory_address,
    vcu_number: anything
  }) do
    stub = Blocktrain::Aggregations::AverageAggregation.new
    allow(stub).to receive(:results) { nil }
    stub
  end
end
