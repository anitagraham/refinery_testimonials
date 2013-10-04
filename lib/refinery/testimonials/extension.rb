module Refinery
  module Testimonials
    module Extension
      def testimonials_relationships
        attr_accessible :testimonials_show, :testimonials_count, :testimonials_select
      end
    end
  end
end

ActiveRecord::Base.send(:extend, Refinery::Testimonials::Extension)
