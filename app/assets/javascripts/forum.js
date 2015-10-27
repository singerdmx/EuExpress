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

    var forumController = function ($scope, $log, $compile, ForumService) {
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
        };

        var renderCategoriesTable = function (categories) {
            $log.info('categories', categories);
            var template = _.template(htmlTemplates.forums);
            var columns = [
                {
                    'sTitle': 'Category',
                    'sClass': 'center panel-title titleColumn',
                },
                {
                    'sTitle': 'Forums',
                    'sClass': 'center panel-title contentColumn',
                    'render': function (data, type, row) {
                        return template({data: data});
                    }
                },
            ]

            var data = _.map(categories, function (c) {
                return [c.category_name, c]
            });

            var tableDefinition = {
                aaData: data,
                aoColumns: columns,
                columnDefs: [
                    {orderable: false, targets: 1},
                ],
                bLengthChange: false,
                bInfo: false,
            };
            $log.info('Categories table definition', tableDefinition);
            $('table#categoriesTable').dataTable(tableDefinition);
            $compile($('div#categoriesTableDiv'))($scope);
        };

        $scope.init = function () {
            ForumService.getCategories().then(renderCategoriesTable, onError);
        };
        $scope.toggleFavorite = function (category, forum) {
            $log.info('toggleFavorite: category '+ category + ', forum ' + forum);
        };
        $scope.selectForum = function (category, forum) {
            $log.info('selectForum: category '+ category + ', forum ' + forum);
        };
    };

    forum.controller('ForumController', ['$scope', '$log', '$compile', 'ForumService', forumController]);
}());