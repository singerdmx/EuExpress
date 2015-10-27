window.htmlTemplates = {}
window.htmlTemplates.forums = '''
  <% _.each( data.forums, function( f ){ %>
    <div style="float:left">
      <i class="star glyphicon glyphicon-star<%= f.favorite ? '' : '-empty' %> forum-icon" ng-click="toggleFavorite('<%= data.id %>', '<%= f.id %>', $event)"></i>
      <span class="forum-item" ng-click="selectForum('<%= data.id %>', '<%= f.id %>', $event)"><%= f.forum_name %></span>
    </div>
  <% }); %>
'''