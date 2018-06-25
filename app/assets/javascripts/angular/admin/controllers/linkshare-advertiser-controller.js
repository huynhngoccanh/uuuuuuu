var ubitruAdminControllerModule = angular.module('ubitruAdmin.controllers');

var LinkshareAdvertiserController = function($scope, $http, $rootScope, $uibModal) {

	$scope.advertisers = [];
	$scope.fetched = false;

	$http.get("/api/v1/admin/merchants/linkshare_advertiser.json").success(function(data) {
		$scope.advertisers = data;
		$scope.fetched = true;
	});

}

ubitruAdminControllerModule.controller('LinkshareAdvertiserController', [ '$scope', '$http', '$rootScope', '$uibModal', LinkshareAdvertiserController]);
