window.htmlTemplates = {}
window.htmlTemplates.forums = '''
  <% _.each( data.forums, function( f ){ %>
    <div style="float:left">
      <i class="star glyphicon glyphicon-star<%= f.favorite ? '' : '-empty' %> forum-icon" ng-click="toggleFavoriteForum('<%= f.forum_name %>', '<%= f.id %>', '<%= data.id %>', $event)"></i>
      <span class="forum-item" ng-click="selectForum('<%= f.forum_name %>', '<%= f.id %>', '<%= data.id %>', $event)"><%= f.forum_name %></span>
    </div>
  <% }); %>
'''
window.htmlTemplates.topic = '''
  <div class="td-title">
    <i ng-click="toggleFavoriteTopic('<%= data.forum %>', '<%= data.id %>', '<%= data.subject %>', $event)" class="star glyphicon glyphicon-star<%= data.favorite ? '' : '-empty' %> forum-icon"></i>
    <span class="forum-item" ng-click="selectTopic('<%= data.forum %>', '<%= data.id %>', $event)"><%= data.subject %></span>
  </div>
  <div class="td-second-row">
    <%= data.user.name %>, <%= data.created_at_ago %>&nbsp; &nbsp; &nbsp;Latest reply: <%= data.last_post_by.name %>, <%= data.last_post_at_ago %>
  </div>
'''