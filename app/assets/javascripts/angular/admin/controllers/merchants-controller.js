var ubitruAdminControllerModule = angular.module('ubitruAdmin.controllers');

var MerchantsController = function($scope, $http, $rootScope, $uibModal) {

	$scope.merchants = [];
	$scope.fetched = false;

	$http.get("/api/v1/admin/merchants.json").success(function(data) {
		$scope.merchants = data;
		$scope.fetched = true;
	});

	$scope.addIn = function(merchant, location) {
		$uibModal.open({
      animation: true,
      windowClass: "modal fade right",
      controller: "MerchantAddInModalController",
      templateUrl: '/templates/admin/merchants/add-in.html',
      resolve: {
        merchant: function() {
          return merchant;
        },
        placement: function() {
        	if(typeof(location) == "object") {
        		return location;
        	} else {
        		return {
	          	location: location,
	          	merchant_id: merchant.id
	          }	
        	}
        }
      }
    });
	}

}

var MerchantAddInModalController = function($scope, $http, $uibModal, $uibModalInstance, Upload, merchant, placement) {

	$scope.placement = placement;
	$scope.merchant = merchant;

	$scope.cancel = function () {
    $uibModalInstance.dismiss('cancel');
  };

  $scope.uploadAttachment = function(file) {
    $scope.placement.image = file;
  }

  $scope.save = function(placement) {
  	if(!!placement.id) {
      Upload.upload({
        url: "/api/v1/admin/placements/"+placement.id+".json",
        method: 'PUT',
        data: {placement: placement}
      }).success(function(data, status, headers, config) {
        if(data.success == null) {
          alert("Saved!")
        } else {
          alert(data.message);
        }
      });
    } else {
      Upload.upload({
        url: "/api/v1/admin/placements.json",
        method: 'POST',
        data: {placement: placement}
      }).success(function(data, status, headers, config) {
        if(data.success == null) {
          alert("Saved!")
          merchant.placements.push(data)
          $uibModalInstance.dismiss('cancel');
        } else {
          alert(data.message);
        }
      });
    }
  }

  $scope.delete = function() {
  	if(confirm("Are you sure?")) {
	  	$http.delete("/api/v1/admin/placements/"+placement.id+".json").success(function(data) { 
	  		if(data.success) {
	  			var delIndex = 0;
	   			angular.forEach(merchant.placements, function(placementObj, i) {
			      if(placementObj.id == placement.id) {
			        delIndex = i;
			      }
			    })
			    merchant.placements.splice(delIndex, 1);
			    $uibModalInstance.dismiss('cancel');
	  		}
	  	});
	  }
  }

}

ubitruAdminControllerModule.controller('MerchantsController', [ '$scope', '$http', '$rootScope', '$uibModal', MerchantsController]);
ubitruAdminControllerModule.controller('MerchantAddInModalController', [ '$scope', '$http', '$uibModal', '$uibModalInstance', 'Upload', 'merchant', 'placement', MerchantAddInModalController]);