#test_runner.py
require 'rubygems'
require 'capybara'
require 'capybara/dsl'
require "capybara-webkit"
require "launchy"
require 'json'
require 'json_test_factory.rb'
require 'capybara-screenshot'
require "test/unit"
Capybara.run_server = false
#Capybara.current_driver = :selenium
#If you switch google to headless it sends different pages...
Capybara.current_driver = :webkit
Capybara.javascript_driver = :webkit
#Capybara.app_host = 'http://smith1024.com/'

# Load the tests from command line?

class JSONTests < Test::Unit::TestCase
	include Capybara::DSL
	tests = JsonTestFactory.load_folder('/Users/dustinsmith/Development/smokeit/tests/')
	tests.each do |t|
		# Define methods for the test
		# Must start with _test for testRunner to pick em up
  	define_method "test_#{t.test_name}" do
  		Capybara.app_host = t.url
  		puts t.explanation
  		puts t.test_name
			  t.steps.each do |step|
        	if step.action == 'visit'
        		visit(step.what)
        	end
        	if step.action == 'fill_in'
        		fill_in step.what, :with => step.with
        	end
        	if step.action == 'click'
        		#find(step.what).click()
        		click_on(step.what)
        	end
        	if step.action == 'check'
        		#Might need to scope this
        		within(step.what) do
  					#	fill_in 'Name', :with => 'Jimmy'
            	assert(has_content?(step.with))
            end
        	end
          if step.action == 'screenshot'
          	info = screenshot_and_save_page
          	#puts info[:image]
            #screenshot_and_open_image
          end
          if step.action == 'resize'
            page.driver.resize_window(step.x, step.y)
          end
        end
  	end
	end
end
