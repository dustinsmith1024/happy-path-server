require 'capybara'
require 'capybara/dsl'
require 'capybara/poltergeist'
class Scenario < ActiveRecord::Base
	has_many :steps
	has_many :results
	accepts_nested_attributes_for :steps
  attr_accessible :description, :name, :url
	@queue = :web_tests

	def self.perform(id)
		# Resques responds to the perform() method to run the task
		require "test/unit"
		require 'test/unit/testsuite' 
		require 'test/unit/ui/console/testrunner'
		require 'test_runner.rb'
		require 'my_test_runner.rb'

		# create a new empty TestSuite, giving it a name
		scenario = Scenario.find(id)
		#my_tests = Test::Unit::TestSuite.new('hi')

		#my_tests << JSONTests.new("test_" + scenario.test_name)  # calls MyTest#test_1

		#run the suite
		#result = ReturnResultRunner.run(my_tests)
		#passed = result.passed?

		#puts 'passed? :', passed
		scenario.run
	end

	def explanation
  	name + ' ' + description
  end

  def test_name
		name.gsub(/-/,'_').gsub(/[^0-9A-Za-z_]/, '')
		"smith1024com"
  end

	include Capybara::DSL
  def run
  	# run the test and stor results to results?
		# Define methods for the test
		# Must start with _test for testRunner to pick em up
		Capybara.app_host = url
		Capybara.default_driver = :webkit

		puts explanation
		puts test_name
		@result = results.new(:status=>true)
		begin
			puts steps
		  steps.each do |step|
	    	if step.action == 'visit'
	    		visit(step.what)
	    	end
	    	if step.action == 'fill_in'
	    		fill_in step.what, :with => step.with
	    	end
	    	if step.action == 'click'
	    		#find(step.what).click() # To click on things like divs
	    		puts 'click'
	    		click_on(step.what)
	    	end
	    	if step.action == 'check'
	    		#Might need to scope this
	    		puts 'check'
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
	  rescue => e
	  	puts e
	  	@result.message = e
	  	@result.status = false
	  end
	  @result.save

  end
end
