class Step < ActiveRecord::Base
  belongs_to :scenario
  attr_accessible :action, :what, :with, :x, :y
end
