(function () {
    var forum = angular.module('forum', ['ngAnimate', 'ui.bootstrap']);

    var forumService = function ($http, $log) {
        var getForums = function () {
            return $http.get('/forums.json')
                .then(function (response) {
                    $log.info(response.data);
                    return response.data;
                });
        };

        return {
            getForums: getForums,
        };
    };

    forum.service('ForumService', forumService);

    var forumController = function ($scope, $log, ForumService) {
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
            ForumService.getForums();
        }
    };

    forum.controller('ForumController', forumController);
}());