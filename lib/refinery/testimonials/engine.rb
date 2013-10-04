module Refinery
  module Testimonials
    class Engine < Rails::Engine
      include Refinery::Engine
      isolate_namespace Refinery::Testimonials

      engine_name :refinery_testimonials

      def self.register_testimonials(tab)
        tab.name = "testimonials"
        tab.partial = "/refinery/testimonials/admin/testimonials/tabs/testimonials"
      end

      before_inclusion do
        Refinery::AdminController.send :helper, Refinery::Admin::TestimonialsHelper
      end

      initializer "register refinerycms_testimonials plugin" do
        Refinery::Plugin.register do |plugin|
          plugin.name = "testimonials"
          plugin.url = proc { Refinery::Core::Engine.routes.url_helpers.testimonials_admin_testimonials_path }
          plugin.pathname = root
          plugin.activity = {
            :class_name => :'refinery/testimonials/testimonial',
            :title => 'name'
          }
        end
      end
      
      config.to_prepare do
        require 'refinerycms-pages'
        # puts "========= Sending testimonials control page relationship ============"
        Refinery::Page.send :testimonials_relationships
      end

      config.after_initialize do
        Refinery.register_extension(Refinery::Testimonials)
        Refinery::Pages::Tab.register do |tab|
          register_testimonials tab
        end
      end

    end
  end
end
