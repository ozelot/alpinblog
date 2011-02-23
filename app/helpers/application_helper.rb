module ApplicationHelper

  # Return logo image
  def logo
      image_tag("logo.png", :alt => "Alpine Blog")
  end

  # Return a title on per page basis
  def title
    base_title = "Ruby on Rails Tutorial Sample App"
    if @title.nil?
      base_title
    else
      "#{base_title} | #{@title}"
    end
  end
end
