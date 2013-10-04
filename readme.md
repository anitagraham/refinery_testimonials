Testimonials plugin for RefineryCMS
http://github.com/resolve/Refinery

This is a rebuild of the original refinerycms-testimonials. It works for Refinerycms 2.1
The method of controlling the display of testimonials on pages has changed. 





Show a Random Testimonial On Any Page
=====================================
If like us you wish to show a random testimonial on pages you need to follow these
two basic steps:

1. Add <%= display_page_testimonial_if_setup %> into your layout where you would like to display them
   -> We've put ours in the sidebar under shared/_content_page.html.erb

2. Change the 'show_testimonials_on_pages' setting in the backend, there are three options:
   -> all  # Show one on every page (except testimonials)
   -> none # Turn off the random testimonial on all pages
   -> comma seperated list of page titles you want them on, i.e: news, contact us, home


If you want to run the tests add the following to environments/test.rb
config.gem "thoughtbot-shoulda", :lib => "shoulda", :source => "http://gems.github.com"
config.gem "mocha"