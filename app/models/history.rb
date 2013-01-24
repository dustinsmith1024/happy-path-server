class History < ActiveRecord::Base
  belongs_to :screenshot
  attr_accessible :email
end
