window.htmlTemplates = {}
window.htmlTemplates.forums = '''
  <% _.each( data.forums, function( f ){ %>
    <div style="float:left">
      <i class="star glyphicon glyphicon-star<%= f.favorite ? '' : '-empty' %> forum-icon" ng-click="toggleFavoriteForum('<%= f.forum_name %>', '<%= f.id %>', '<%= data.id %>', $event)"></i>
      <span class="forum-item" ng-click="selectForum('<%= f.forum_name %>', '<%= f.id %>', '<%= data.id %>', $event)"><%= f.forum_name %></span>
    </div>
  <% }); %>
'''
window.htmlTemplates.topics = '''
'''