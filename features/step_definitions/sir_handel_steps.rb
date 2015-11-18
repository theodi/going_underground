And(/^I do not authenticate$/) do

end

###Then /^I should get redirected to "([^"]*)"$/ do |path|
####  require 'pry'
####  binding.pry
###  expect(last_response.status).to eq 302
###  redirect_target = "/#{last_response.original_headers['location'].split('/')[3..-1].join('/')}"
###
###  expect(redirect_target.split('?')[0]).to match /\/?#{path}/
###
###  request redirect_target
###end
