class Size < ActiveRecord::Base
  belongs_to :screenshot
  attr_accessible :height, :width, :file

  def file_link
  	# Will use to make the link be local to the URL
  	file if file
  end

end
