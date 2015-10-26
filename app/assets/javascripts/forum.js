(function () {
    var forum = angular.module('forum', ['ngAnimate', 'ui.bootstrap']);
    var forumController = function ($scope) {
        $scope.oneAtATime = true;

        $scope.forumStatus = {
            open: true,
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

        $scope.init = function () {
        }
    };

    forum.controller('ForumController', ['$scope', forumController]);
}());