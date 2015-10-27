window.htmlTemplates = {}
window.htmlTemplates.forums = '''
  <% _.each( data.forums, function( f ){ %>
    <i class="glyphicon glyphicon-star-empty forumIcon"></i>
    <span class="forumItem"><%= f.forum_name %></span>
  <% }); %>
'''