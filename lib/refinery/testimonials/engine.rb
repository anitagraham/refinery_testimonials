
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

      initializer "register refinerycms-testimonials plugin" do
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
        # Decorators.register! root
        require 'refinerycms-pages'
        Refinery::Page.send :testimonial_fields
      end

      config.after_initialize do
        Refinery.register_extension(Refinery::Testimonials)
        puts "------------ Refinery::Testimonials Registered ----------"
        Refinery::Pages::Tab.register do |tab|
          register_testimonials tab
        end
      end

    end
  end
end
