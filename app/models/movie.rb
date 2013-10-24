class Movie < ActiveRecord::Base
  def self.valid_ratings
    ['G','PG','PG-13','R']
  end 
end
