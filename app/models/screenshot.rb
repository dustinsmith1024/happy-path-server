class Screenshot < ActiveRecord::Base
	before_create :save_token
	has_many :sizes
	has_many :histories
	accepts_nested_attributes_for :sizes
	attr_accessible :description, :token, :email, :name, :url, :file, :delivered, :sizes_attributes
	@queue = :web_tests

	def status
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

  def url_secrets # TODO go add this everywhere or find a better way?  SESSION?
  	"&token=#{token}&email=#{email}"
  end

  def test_name
		name.gsub(/-/,'_').gsub(/[^0-9A-Za-z_]/, '') if name
  end

	include Capybara::DSL
  def run
  	# These might be definable somewhere else?
		Capybara.app_host = url
		Capybara.default_driver = :webkit
		
		if Rails.env.production?
			# Needs Xfvb on server
			headless = Headless.new
  		headless.start
  	end
		
		begin
			visit(url)
		  sizes.each do |size|
		  	if size.height && size.width
	      	page.driver.resize_window(size.width, size.height)
	      	size.file = screenshot_and_save_page[:image]
	      	size.save
	      	#screenshot_and_open_image
	      end
	    end
	  rescue => e
	  	# TODO: Handle these errors
	  	puts e
	  	#@result.message = e
	  	#@result.status = false
	  end
	  # TODO: Could possibly queue this too
	  ScreenshotMailer.screenshot_email(self).deliver
	  self.histories.create(email: self.email)
	  self.delivered = Time.now
	  self.save!
  end

  private

    def save_token
    	self.token = SecureRandom.uuid unless self.token
  	end
end
