Refinery::PagesController.class_eval do
  append_before_filter :get_pagecontrol, :only => [:create, :edit]
  
  protected
   
    def get_pagecontrol
      logger.debug "=============== Get Page Testimonials Control Page Decorator ==============="
      if @page.pagecontrol.nil?
        logger.debug "=============== Creating new page/testimonials/control record ==============="
        @pc = Refinery::Testimonials::Pagecontrol.new(:testimonials_show => false, :testimonials_count => 0, :testimonials_select => 'Random' )
        @page.pagecontrol = @pc
      else
        @pc = @page.pagecontrol
      end 
    end
end