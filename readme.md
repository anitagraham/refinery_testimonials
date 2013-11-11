# Testimonials plugin for RefineryCMS
http://github.com/resolve/Refinery

Version 2.0 is a rewrite of the original refinerycms-testimonials. It is compatible with Refinerycms 2.1

# How to install

In your Gemfile, add the gem:

```ruby
gem 'refinerycms-testimonials', '~> 2.0'
```

Now, run `bundle install` and the gem should install.

To install the migrations, run:

    rails generate refinery:testimonials
    rake db:migrate

Add Testimonials to the database
================================

You can now add testimonials to the databasse through the Refinery CMS.
Each testimonial includes
+ quote (the actual testimonial)
+ name (of testimonial sender)
+ company ( ditto )
+ website ( ditto )
+ jobtitle ( ditto )
+ received_channel (letter, email, facebook, twitter)

Display Testimonials on a page
==============================
Each page now has a testimonials tab which can be used to set how testimonials should be displayed on that page

+ Show Testimonials on this page (default:  no)
+ How many testimonials to show (n, 0 means show all)
+ How to select and order which testimonials to show (Random, Most Recent First)


Changes to Layout Templates
====================================
To display testimonials add <%= yield :testimonials unless @testimonials.nil? %> in a layout template.
For example, in application.html.erb

''''
<%=  yield :testimonials unless @testimonials.nil? %>
''''

This will result in the following on your page

''''
<section id="testimonials">
  <ul>
    <%= render @testimonials %>
  </ul>
</section>
''''

In this default setup a testimonial will be a list item thus:

''''
<li class="testimonial <%= testimonial.received_channel%>">
  <span class="testimonial_date"><%=testimonial.received_date%></span>
  <blockquote>
    <p><%= raw(testimonial.quote) %></p>
      <cite>
        <%= testimonial.name %>
        <span class="testimonial_jobtitle"><%=testimonial.job_title%></span>
        <span class="testimonial_company"><%= link_to_unless testimonial.website.blank?, testimonial.company, testimonial.website  %></span>
      </cite>
    </blockquote>
</li>
''''


