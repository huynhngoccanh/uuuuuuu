var ubitruAdminControllerModule = angular.module('ubitruAdmin.controllers');

var AvantAdvertiserController = function($scope, $http, $rootScope, $uibModal) {

	$scope.advertisers = [];
	$scope.fetched = false;

	$http.get("/api/v1/admin/merchants/avant_advertiser.json").success(function(data) {
		$scope.advertisers = data;
		$scope.fetched = true;
	});
}


ubitruAdminControllerModule.controller('AvantAdvertiserController', [ '$scope', '$http', '$rootScope', '$uibModal', AvantAdvertiserController]);
// ubitruAdminControllerModule.controller('AvantAdvertiserAddInModalController', [ '$scope', '$http', '$uibModal', '$uibModalInstance', 'Upload', 'merchant', 'placement', AvantAdvertiserAddInModalController]);