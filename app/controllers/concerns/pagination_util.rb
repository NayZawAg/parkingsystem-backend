require 'active_support/concern'

# PaginationUtil
module PaginationUtil
  extend ActiveSupport::Concern

  DEFAULT_PAGE = 1
  DEFAULT_PER_PAGE = 10

  private_constant :DEFAULT_PAGE
  private_constant :DEFAULT_PER_PAGE

  private

  def pagination_dict(collection)
    {
      current_page: collection.current_page,
      next_page: collection.next_page,
      prev_page: collection.prev_page,
      total_pages: collection.total_pages,
      total_count: collection.total_count
    }
  end

  def page
    params.permit(:page)[:page] || DEFAULT_PAGE
  end

  def per_page
    params.permit(:per_page)[:per_page] || DEFAULT_PER_PAGE
  end
end
