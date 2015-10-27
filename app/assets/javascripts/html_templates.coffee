window.htmlTemplates = {}
window.htmlTemplates.forums = '''
  <% _.each( data.forums, function( f ){ %>
    <i class="star glyphicon glyphicon-star-empty forumIcon" ng-click="toggleFavorite('<%= data.id %>', '<%= f.id %>', $event)"></i>
    <span class="forumItem" ng-click="selectForum('<%= data.id %>', '<%= f.id %>', $event)"><%= f.forum_name %></span>
  <% }); %>
'''