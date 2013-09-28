Refinery::PagesController.class_eval do
  append_before_filter :get_testimonials, :only => [:show]
  
  protected
   
    def get_testimonials
    	logger.debug "=============== Get Testimonials Page Decorator ==============="
      if @page.testimonials_show 
      	@testimonials = Refinery::Testimonials::Testimonial.scoped
       	logger.debug "=============== Testimonials found: #{@testimonials.count} ==============="
       	
       	@testimonials = page.testimonials_select=='Random' ? @testimonials.sample : @testimonials.recent
       	@testimonials = @testimonials.limit(page.testimonials_count	) unless page.testimonials_count==0
       	
       	logger.debug "=============== Testimonials to display: #{@testimonials.count} ==============="
      else 
      	logger.debug "=============== Don't show testimonials on this page ==============="
      end
    end
end