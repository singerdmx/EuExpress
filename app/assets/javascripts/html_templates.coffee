window.htmlTemplates = {}
window.htmlTemplates.forums = '''
  <% _.each( data.forums, function( f ){ %>
    <i class="glyphicon glyphicon-star-empty forumIcon" ng-click="toggleFavorite('<%= data.id %>', '<%= f.id %>')"></i>
    <span class="forumItem" ng-click="selectForum('<%= data.id %>', '<%= f.id %>')"><%= f.forum_name %></span>
  <% }); %>
'''