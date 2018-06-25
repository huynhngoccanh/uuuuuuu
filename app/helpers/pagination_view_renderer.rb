require 'will_paginate'

class PaginationViewRenderer < WillPaginate::ActionView::LinkRenderer
  protected

    def pagination
      items = @options[:page_links] ? windowed_page_numbers : []
      items.unshift :previous_page
      items.unshift :first_page
      items.push :next_page
      items.push :last_page
    end

    def first_page
      label = @options[:first_label] || @template.will_paginate_translate(:first_label) { 'First' }
      previous_or_next_page(current_page == 1 ? nil : 1, label, "first_page")
    end

    def last_page
      label = @options[:last_label] || @template.will_paginate_translate(:last_label) { 'Last' }
      previous_or_next_page(current_page == total_pages ? nil : total_pages, label, "last_page")
    end
end