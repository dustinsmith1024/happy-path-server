class ScreenshotMailer < ActionMailer::Base
  default :from => "notifications@smith1024.com"
 
  def screenshot_email(screenshot)
    @screenshot = screenshot
    screenshot.sizes.each_with_index do |size, index|
    	attachments["shot_#{index}.png"] = File.read(size.file)
    end
    mail(:to => screenshot.email,
    	 :subject => "Your screenshot for #{screenshot.url}")
  end
end
