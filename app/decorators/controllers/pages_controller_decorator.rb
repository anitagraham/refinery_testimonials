Refinery::PagesController.class_eval do
  append_before_filter :get_testimonials, :only => [:show]
  protected

  def get_testimonials
    if @page.testimonials_show
      @testimonials = Refinery::Testimonial.scoped
      @testimonials = page.testimonials_select=='Random' ? @testimonials.sample : @testimonials.recent
      @testimonials = @testimonials.limit(page.testimonials_count  ) unless page.testimonials_count==0
    end
  end
end