class Screenshot < ActiveRecord::Base
	before_create :uid_the_id
	has_many :sizes
	self.primary_key="id"
	accepts_nested_attributes_for :sizes
	attr_accessible :description, :email, :name, :url, :file, :delivered, :sizes_attributes
	@queue = :web_tests

	def status
		#puts "------- #{delivered}delivered"
		return delivered.to_s if delivered
		"Queued up"
	end

	def self.perform(id)
		# Resques responds to the perform() method to run the task
		Screenshot.find(id).run
	end

	def explanation
  	"#{name} #{description}"
  end

  def test_name
		name.gsub(/-/,'_').gsub(/[^0-9A-Za-z_]/, '') if name
  end

	include Capybara::DSL
  def run
  	# run the test and stor results to results?
		# Define methods for the test
		# Must start with _test for testRunner to pick em up
		Capybara.app_host = url
		Capybara.default_driver = :webkit

		#puts explanation
		begin
			#puts sizes
			visit(url)
		  sizes.each do |size|
		  	#puts size.height
		  	#puts size.width
		  	if size.height && size.width
	      	page.driver.resize_window(size.width, size.height)
	      	size.file = screenshot_and_save_page[:image]
	      	size.save
	      	#screenshot_and_open_image
	      end
	    end
	  rescue => e
	  	puts e
	  	#@result.message = e
	  	#@result.status = false
	  end
	  #UserMailer.welcome_email(@user).deliver
	  ScreenshotMailer.screenshot_email(self).deliver
	  self.delivered = Time.now
	  #puts delivered
	  self.save!
		#puts "email delivered to  #{email}"
  end

  private

    def uid_the_id
    	self.id = SecureRandom.uuid
    	puts self.id
  	end
end
