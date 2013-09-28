module Refinery
  module Testimonials
    module Extension
      def page_fields
        attr_accessible :testimonials_show, :testimonials_count, :testimonials_select
      end
    end
  end
end

ActiveRecord::Base.send(:extend, Refinery::Testimonials::Extension)