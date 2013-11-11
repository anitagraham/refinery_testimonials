# Testimonials plugin for RefineryCMS
http://github.com/resolve/Refinery

Version 2.0 is a rewrite of the original refinerycms-testimonials. It is compatible with Refinerycms 2.1

## How to install

In your Gemfile, add the gem:

```ruby
gem 'refinerycms-testimonials', '~> 2.0'
```

Now, run `bundle install` and the gem should install.

To install the migrations, run:

    rails generate refinery:testimonials
    rake db:migrate

## Add Testimonials to the database


You can now add testimonials to the database through the Refinery CMS.
Each testimonial includes
+ quote (the actual testimonial)
+ name (of testimonial sender)
+ company ( ditto )
+ website ( ditto )
+ jobtitle ( ditto )
+ received_channel (letter, email, facebook, twitter)

##Control Testimonial display on a page

Each page now has a testimonials tab which can be used to set how testimonials should be displayed on that page

+ Show Testimonials on this page (default:  __no__)
+ How many testimonials to show (n, __0__ means show all)
+ How to select and order which testimonials to show (Random, __Most Recent First__)


## Changes to Layout Templates

To display testimonials add `<%= yield :testimonials unless @testimonials.nil? %>` in a layout template.
For example, in application.html.erb

````ruby
<%=  yield :testimonials unless @testimonials.nil? %>
````

This will result in the following on your page

````HTML+ERB
<section id="testimonials">
  <ul>
    <%= render @testimonials %>
  </ul>
</section>
````

In this default setup a testimonial will be a list item thus:

````HTML+ERB
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
````

For more control over what is displayed you can render the @testimonials collection yourself as html or, as shown below, as json.

````ruby
<%= render "shared/testimonials", :mustache=>{:testimonials => @testimonials.as_json}   %>
````

producing

''''json
"testimonials" : [
[0]{
  "company" : "Client Company",
  "created_at" : "Sat, 05 Oct 2013 22:04:41 CST +09:30",
  "id" : "1",
  "job_title" : "manager",
  "name" : "Jo Jones",
  "position" : "nil",
  "quote" : "<p>We liked your work</p> ",
  "received_channel" : "Email",
  "received_date" : "Tue, 01 Mar 2011",
  "updated_at" : "Sat, 05 Oct 2013 22:04:41 CST +09:30",
  "website" : "www.clientcompany.com"
}]
''''

will allow you to use a mustache template to render the parts of the testimonial you want displayed.

''''
<section id="testimonials">
  <ul>
    {{#testimonials}}
    <li>
      <span class="date">{{received_date}}</span>
      <blockquote>
        {{{quote}}}
        <cite>
          {{name}}
        </cite>
      </blockquote>
    </li>
    {{/testimonials}}
  </ul>
</section>
''''




