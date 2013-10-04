class RenameRefineryTestimonialPagecontrolsColumns < ActiveRecord::Migration

  def change
    change_table :refinery_testimonials_pagecontrols do |t|
      t.rename  :show, :testimonials_show
      t.rename  :count, :testimonials_count
      t.rename  :select, :testimonials_select
    end

  end

end
