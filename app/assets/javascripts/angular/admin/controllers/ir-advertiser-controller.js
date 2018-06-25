var ubitruAdminControllerModule = angular.module('ubitruAdmin.controllers');

var IrAdvertiserController = function($scope, $http, $rootScope, $uibModal) {

	$scope.advertisers = [];
	$scope.fetched = false;

	$http.get("/api/v1/admin/merchants/ir_advertiser.json").success(function(data) {
		$scope.advertisers = data;
		$scope.fetched = true;
	});


}

ubitruAdminControllerModule.controller('IrAdvertiserController', [ '$scope', '$http', '$rootScope', '$uibModal', IrAdvertiserController]);
