class AnalyticsController < ApplicationController
  def show
    query = "SELECT search_term, COUNT(search_term)
            FROM searches s1
            WHERE NOT EXISTS (
              SELECT 1
              FROM searches s2
              WHERE s2.search_term > s1.search_term
                AND position(s1.search_term in s2.search_term) = 1)
            GROUP BY search_term
            ORDER BY COUNT(search_term) DESC"

    # Incomplete searches are on per user basis! Handle this!   
    @top_searches = ActiveRecord::Base.connection.execute(query).to_a

    respond_to do |format|
      format.html { render partial: 'show' }
    end
  end
end