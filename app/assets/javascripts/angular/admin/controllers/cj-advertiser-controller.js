var ubitruAdminControllerModule = angular.module('ubitruAdmin.controllers');

var CjAdvertiserController = function($scope, $http, $rootScope, $uibModal) {

	$scope.advertisers = [];
	$scope.fetched = false;

	$http.get("/api/v1/admin/merchants/cj_advertiser.json").success(function(data) {

		$scope.advertisers = data;
		$scope.fetched = true;
	});

}

ubitruAdminControllerModule.controller('CjAdvertiserController', [ '$scope', '$http', '$rootScope', '$uibModal', CjAdvertiserController]);
