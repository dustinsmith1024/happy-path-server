class Screenshot < ActiveRecord::Base
	before_create :save_token
	has_many :sizes
	has_many :histories
	accepts_nested_attributes_for :sizes
	attr_accessible :description, :error, :token, :email, :name, :url, :file, :delivered, :sizes_attributes
	@queue = :web_tests
	validates_format_of :url, :with => URI::regexp(%w(http https))
  	validates :email,   
              :presence => true,   
              :format => { :with => /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i }  
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
	self.error = false
	Capybara.app_host = url
	Capybara.default_driver = :webkit
	
	if Rails.env.production?
		# Needs Xfvb on server
		headless = Headless.new
		headless.start
	end
	
	begin
		visit(url)
		files = []
	  sizes.each do |size|
			if size.height && size.width
	      	page.driver.resize_window(size.width, size.height)
	      	screenshot = screenshot_and_save_page
	      	#screenshot_and_open_image
	      	size.file = screenshot[:image]
	      	files << size.file
	      	files << screenshot[:html]
	      	size.save
			end
    end
		rescue => e
  	  # TODO: Handle these errors
  	  puts e
  	  self.error = true
  	  ScreenshotMailer.screenshot_error_email(self).deliver
		end
	  # TODO: Could possibly queue this too
	ScreenshotMailer.screenshot_email(self).deliver unless self.error
	self.histories.create(email: self.email)
	self.delivered = Time.now
	self.save!
	files.each do |file|
		File.delete(file)
	end
  end

  private

    def save_token
    	self.token = SecureRandom.uuid unless self.token
  	end
end
