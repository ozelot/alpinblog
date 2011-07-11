module ApplicationHelper

  # Return logo image
  def logo
      image_tag("logo.png", :size => "250x83" ,:alt => "AlpinFreunde", :class => "logo")
  end

  # Return a title on per page basis
  def title
    base_title = "Alpinfreunde"
    if @title.nil?
      base_title
    else
      "#{base_title} | #{@title}"
    end
  end
end
