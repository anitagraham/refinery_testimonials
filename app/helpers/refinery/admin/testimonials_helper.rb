module Refinery
  module Admin
    module TestimonialsHelper
      def create_testimonial_control(page)
        Refinery::Testimonials::Pagecontrol.new(:testimonials_show => false, :testimonials_count => 0, :testimonials_select => 'Random', :page_id => @page.id )

        page.pagecontrol.build( :testimonial_show => false, :testimonial_count => 0, :testimonial_select => 'Random' )
      end
    end
  end
end
