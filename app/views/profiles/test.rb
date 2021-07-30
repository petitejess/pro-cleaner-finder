# require 'faraday'
# require 'json'
# # <div class="container" style="margin-top: 200px;">
# # <%= form_tag(root_path, method: "get", remote: true) do %>
# #   <%= text_field_tag :search, params[:search], placeholder: "Enter search term" %>
# #   <%= submit_tag "Search" %>
# # <% end %>
# # </div>


# #     if params[:search]
# #       @search_results_posts = Post.search_by_title_and_body(params[:search])
# #       respond_to do |format|
# #         format.js { render partial: 'search-results'}
# #       end
# #     else
# #       @posts = Post.all
# #     end


# #   def self.ajax_search(keyword)
# #     @suburbs = Suburb.all
# #     @postcodes = Postcode.all
# #     paginate :per_page => 5, :page => page,
# #       :conditions => ["name LIKE '%?%' OR postal_code like '%?%'", keyword, keyword],   order => 'name'
# #   end


# url = 'https://v0.postcodeapi.com.au/suburbs.json'
# response = Faraday.get(url, {q: 'syd'}, {'Accept' => 'application/json; indent=4'})

# results = JSON.parse(response.body)

# suburbs = []
# states = []
# postcodes = []

# results.each_with_index do |result, i|
#   suburbs << result["name"]
#   states << result["state"]["abbreviation"]
#   postcodes << result["postcode"].to_s
#   puts suburbs[i] + ", " + states[i] + " " + postcodes[i]
# end