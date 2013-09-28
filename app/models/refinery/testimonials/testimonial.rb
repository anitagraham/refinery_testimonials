module Refinery
	module Testimonials
		class Testimonial < Refinery::Core::BaseModel
			
			# Constants for how to show the testimonials
			ORDER = %w[Random Recent]
			CHANNELS = %w[Letter Email Facebook Twitter]
			
			attr_accessible :name, :quote, :company, :job_title, :website, :received_date, :received_channel, :position, :display 

			acts_as_indexed :fields => [:name, :quote, :company, :job_title, :website]

			validates :name, :presence => true, :uniqueness => true
			validates :quote, :presence => true
			
			scope :recent, lambda { order('created_at DESC')}
			scope :sample, lambda { order('random()')}
			
		  def flash_name
		    "Quote by #{self.name}"
		  end
 
		end
	end
end
