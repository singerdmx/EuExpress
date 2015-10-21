(function () {
    var forum = angular.module('forum', ['ngAnimate', 'ui.bootstrap']);
    var forumController = function ($scope) {
        $scope.oneAtATime = true;

        $scope.forumStatus = {
            isFirstOpen: true,
            isFirstDisabled: false
        };
        $scope.topicStatus = {
            isFirstOpen: true,
            isFirstDisabled: false
        };
        $scope.postStatus = {
            isFirstOpen: true,
            isFirstDisabled: false
        };
    };

    forum.controller('ForumController', forumController);
}());