module ApplicationHelper
  def page_title(title = '')
    base_title = 'Bananance - Banana Exchange'

    title.empty? ? base_title : "#{title} | #{base_title}"
  end
end
