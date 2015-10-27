(function () {
    var forum = angular.module('forum', ['ngAnimate', 'ui.bootstrap']);

    var forumService = function ($http, $log) {
        var getCategories = function () {
            return $http.get('/categories')
                .then(function (response) {
                    $log.info('GET /categories response', response);
                    return response.data;
                });
        };

        return {
            getCategories: getCategories,
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

        var onError = function (reason) {
            $log.error('onError', reason);
        }

        var renderCategoriesTable = function (categories) {
            $log.info('categories', categories);
            var columns = [
                {
                    'sTitle': 'Category',
                    'sClass': 'center panel-title',
                },
                {
                    'sTitle': 'Forums',
                    'sClass': 'center panel-title',
                },
            ]

            var data = _.map(categories, function (c) {
                var result = [c.category_name, _.map(c.forums, function (f) {
                    return f.forum_name;
                }).join(', ')];
                return result;
            });

            var tableDefinition = {
                aaData: data,
                aoColumns: columns,
                columnDefs: [
                    {orderable: false, targets: 1}
                ],
                bLengthChange: false,
                bInfo: false,
            };
            $log.info('Categories table definition', tableDefinition);
            $('table#categoriesTable').dataTable(tableDefinition);
        };

        $scope.init = function () {
            ForumService.getCategories().then(renderCategoriesTable, onError);
        }
    };

    forum.controller('ForumController', forumController);
}());