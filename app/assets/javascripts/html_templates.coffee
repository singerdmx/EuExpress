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
  <div class="messageMeta">
    <div class="privateControls">
      <%= data.user.name %>, <%= data.created_at_ago %>&nbsp; &nbsp; &nbsp;Latest reply: <%= data.last_post_by.name %>, <%= data.last_post_at_ago %>
    </div>
    <div class="publicControls">
      <% if (data.edit) { %>
        <a class="item" ng-click="openModal('Edit Topic', '<%= data.id %>', '',  '<%= data.subject %>', $event)">Edit</a>
        <a class="item" ng-click="deleteTopic('<%= data.forum %>', '<%= data.id %>')">Delete</a>
      <% } %>
    </div>
  </div>
'''
window.htmlTemplates.userInfo = '''
  <div class="messageUserInfo">
    <div class="messageUserBlock ">
      <div class="avatarHolder">
        <span class="helper"></span>
        <a class="avatar" href="members/user-id/">
          <img width="65" height="65" alt="Avatar" src="<%= data.picture %>">
        </a>
      </div>
      <h3 class="userText">
        <a class="username" href="members/user-id/"><%= data.name %></a>
        <em class="userTitle">Level: Cupcake</em>
      </h3>
      <span class="arrow">
        <span></span>
      </span>
    </div>
  </div>
'''

window.htmlTemplates.postBody = '''
  <div class="messageInfo"><%= data.body_text %></div>
  <div class="messageMeta">
    <div class="privateControls">
      <span class="item">
        <abbr><%= data.updated_at_time %></abbr>
      </span>
    </div>
    <div class="publicControls">
      <% if (data.edit) { %>
        <a class="item" ng-click="openModal('Edit Post', '<%= data.topic %>', '<%= data.id %>',  '', $event)">Edit</a>
        <a class="item" ng-click="deletePost('<%= data.topic %>', '<%= data.id %>')">Delete</a>
      <% } %>
      <a class="item">Like</a>
      <a title="Reply, quoting this message" class="item">Reply</a>
    </div>
  </div>
'''