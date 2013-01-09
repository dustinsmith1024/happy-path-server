class Result < ActiveRecord::Base
  belongs_to :scenario
  attr_accessible :message, :status
end
