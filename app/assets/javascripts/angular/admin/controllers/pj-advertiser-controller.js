var ubitruAdminControllerModule = angular.module('ubitruAdmin.controllers');

var PjAdvertiserController = function($scope, $http, $rootScope, $uibModal) {

	$scope.advertisers = [];
	$scope.fetched = false;

	$http.get("/api/v1/admin/merchants/pj_advertiser.json").success(function(data) {
		$scope.advertisers = data;
		$scope.fetched = true;
	});

}

ubitruAdminControllerModule.controller('PjAdvertiserController', [ '$scope', '$http', '$rootScope', '$uibModal', PjAdvertiserController]);
