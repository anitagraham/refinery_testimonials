require 'test_helper'

class PageTest < ActiveSupport::TestCase

  context "The Page class has been extended and now it" do
    should_have_instance_methods :testimonials_show, :testimonials_count, :testimonials_select
  end

end
