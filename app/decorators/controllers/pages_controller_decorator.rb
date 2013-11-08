Refinery::PagesController.class_eval do
  append_before_filter :get_testimonials, :only => [:show]
  logger.debug "=======Appended get_testimonials======"
  protected

    def get_testimonials
      logger.debug "---------- Checking Testimonials---------------"
      if @page.testimonials_show
        @testimonials = Refinery::Testimonials::Testimonial.scoped
        logger.debug "---------- There are  #{@testimonials.count} in total ---------------"
        @testimonials = page.testimonials_select=='Random' ? @testimonials.sample : @testimonials.recent
        @testimonials = @testimonials.limit(page.testimonials_count  ) unless page.testimonials_count==0
        logger.debug "---------- Making #{@testimonials.count} available---------------"
      end
    end
end