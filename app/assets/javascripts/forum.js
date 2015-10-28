(function () {
    var forum = angular.module('forum', ['ngAnimate', 'ui.bootstrap']);

    var forumService = function ($http, $log, $q) {
        var addUserFavorite = function (favorite, type) {
            return $http.post('/favorites', {favorite: favorite, type: type})
                .then(function (response) {
                    $log.info('POST /favorites response', response);
                    return response.data;
                });
        };

        var removeUserFavorite = function (favorite, type) {
            return $http.delete('/favorites/' + favorite, {params: {type: type}})
                .then(function (response) {
                    $log.info('DELETE /favorites response', response);
                    return response.data;
                });
        };

        var getCategoriesWithFavorites = function () {
            $log.info('getCategoriesWithFavorites');
            return $q.all([$http.get('/categories'), $http.get('/favorites')]).then(function (response) {
                var categories = response[0].data;
                $log.info('categories', categories);
                var userFavorites = response[1].data;
                $log.info('userFavorites', userFavorites);
                var favoriteForums = [];

                _.each(categories, function (c) {
                    _.each(c.forums, function (f) {
                        if (_.contains(userFavorites.forum, f.id)) {
                            f.favorite = true;
                            favoriteForums.push({
                                id: f.id,
                                name: f.forum_name,
                            });
                        }
                    });
                });
                return {
                    categories: categories,
                    favoriteForums: favoriteForums,
                };
            });
        };
        return {
            getCategories: getCategoriesWithFavorites,
            addUserFavorite: addUserFavorite,
            removeUserFavorite: removeUserFavorite,
        };
    };

    forum.service('ForumService', ['$http', '$log', '$q', forumService]);

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

        var renderCategoriesTable = function (data) {
            var categories = data.categories;
            $scope.favoriteForums = data.favoriteForums;
            $log.info('categories', categories);
            $log.info('favoriteForums', $scope.favoriteForums);
            var template = _.template(htmlTemplates.forums);
            var columns = [
                {
                    'sTitle': 'Category',
                    'sClass': 'center panel-title title-column',
                },
                {
                    'sTitle': 'Forums',
                    'sClass': 'center panel-title content-column',
                    'render': function (data, type, row) {
                        return template({data: data});
                    }
                },
            ]

            var data = _.map(categories, function (c) {
                return [c.category_name, c];
            });

            var tableDefinition = {
                aaData: data,
                aoColumns: columns,
                columnDefs: [
                    {orderable: false, targets: 1},
                ],
                bLengthChange: false,
                bInfo: false,
                dom: '<"categories-table-toolbar">frtip',
                pagingType: 'full_numbers',
            };
            $log.info('Categories table definition', tableDefinition);
            $('table#categoriesTable').dataTable(tableDefinition);
            var refreshButtonHtml = '<button class="btn btn-info" type="button" ng-click="refreshCategoriesTable()"><i class="glyphicon glyphicon-refresh"></i>&nbsp;Refresh</button>';
            $("div.categories-table-toolbar").html(refreshButtonHtml);
            $compile($('div#categoriesTableDiv'))($scope);
            $('div#categoriesTable_paginate a').on('click', function () {
                $compile($('div#categoriesTableDiv'))($scope);
            });
        };

        $scope.init = function () {
            ForumService.getCategories().then(renderCategoriesTable, onError);
        };
        $scope.toggleFavorite = function (name, id, $event) {
            $log.info('toggleFavorite: name ' + name + ', id ' + id);
            var target = $($event.target);
            target.toggleClass('glyphicon-star-empty');
            target.toggleClass('glyphicon-star');
            if (target.attr('class').indexOf('glyphicon-star-empty') < 0) {
                $log.info('POST /favorites: forum = ' + id);
                ForumService.addUserFavorite(id, 'forum');
                $scope.favoriteForums.push({
                    name: name,
                    id: id,
                });
            } else {
                $log.info('DELETE /favorites: forum = ' + id);
                ForumService.removeUserFavorite(id, 'forum');
                $scope.favoriteForums = _.without($scope.favoriteForums,
                    _.findWhere($scope.favoriteForums, {id: id}));
            }
        };
        $scope.selectForum = function (name, id, $event) {
            $log.info('selectForum: name ' + name + ', forum ' + id);
            var oTable = $('table#categoriesTable').dataTable();
            oTable.$('span.selected-forum').removeClass('selected-forum');
            $('div#categories-table-banner span.selected-forum').removeClass('selected-forum');
            var target = $($event.target);
            target.addClass('selected-forum');
            $scope.topicStatus.open = true;
            $scope.selectedForum = {
                id: id,
                name: name,
            }
        };
        $scope.refreshCategoriesTable = function () {
            $('table#categoriesTable').dataTable().fnDestroy();
            ForumService.getCategories().then(renderCategoriesTable, onError);
        };
    };

    forum.controller('ForumController', ['$scope', '$log', '$compile', 'ForumService', forumController]);
}());