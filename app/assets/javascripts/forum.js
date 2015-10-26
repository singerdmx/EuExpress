(function () {
    var forum = angular.module('forum', ['ngAnimate', 'ui.bootstrap']);
    var forumController = function ($scope, $log) {
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
            $log.info('Initializing');
        }
    };

    forum.controller('ForumController', ['$scope', '$log', forumController]);
}());