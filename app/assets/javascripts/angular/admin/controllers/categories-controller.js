var ubitruAdminControllerModule = angular.module('ubitruAdmin.controllers');

var CategoriesController = function($scope, $http, $rootScope) {

}

var CategoryController = function($scope, $http, $rootScope, $uibModal) {
	$scope.taxons = [];
	$http.get("/api/v1/admin/taxonomies/"+taxonomy_id+"/taxons.json").success(function(data) {
		$scope.taxons = data;
	})

	$scope.fetchChild = function(taxon) {
		$http.get("/api/v1/admin/taxonomies/"+taxonomy_id+"/taxons.json", {params: {parent_id: taxon.id}}).success(function(data) {
			taxon.descendants = data;
		})		
	}

	$scope.addNewTaxon = function(taxon, parent) {
		if(taxon == "") {
			taxon = {taxonomy_id: taxonomy_id, parent_id: parent.id, merchants: []}
		}
		$uibModal.open({
      animation: true,
      windowClass: "modal fade right",
      controller: "AddTaxonModalController",
      templateUrl: '/templates/admin/categories/add-taxon.html',
      resolve: {
        taxon: function() {
          return taxon;
        },
        taxons: function() {
          return $scope.taxons;
        },
        parent: function() {
          return parent
        }
      }
    });
  };

}

var AddTaxonModalController = function($scope, $http, $uibModal, $uibModalInstance, taxon, taxons, parent) {

	$scope.taxon = taxon;
	$scope.merchants = [];

	$scope.cancel = function () {
    $uibModalInstance.dismiss('cancel');
  };

  $scope.updateList = function(q) {
  	$http.get("/api/v1/autocompletes/search.json", {params: {q: q}}).success(function(data) {
  		$scope.merchants = data;
  	});
  };

  $scope.addMerchant = function(merchant) {
    var exists = false;
    angular.forEach($scope.taxon.merchants, function(m, i) {
      if(m.id == merchant.id) {
        exists = true;
      }
    })
    if(!exists) {
      $scope.taxon.merchants.push(merchant);  
    }
  }

  $scope.removeMerchant = function(merchant) {
  	var delIndex = 0;
    angular.forEach($scope.taxon.merchants, function(merchantObj, i) {
      if(merchantObj.$$hashKey == merchant.$$hashKey) {
        delIndex = i;
      }
    })
    $scope.taxon.merchants.splice(delIndex, 1);
  }

  $scope.save = function(taxon) {
  	var merchant_ids = []
  	angular.forEach($scope.taxon.merchants, function(merchantObj, i) {
  		merchant_ids.push(merchantObj.id);
  	})
  	taxon.merchant_ids = merchant_ids;
  	if(!!taxon.id) {
      $http.put("/api/v1/admin/taxons/"+taxon.id+".json", {taxon: taxon}).success(function(data) {
        if(data.success == null) {
          $uibModalInstance.dismiss('cancel');
        } else {
          
        }
      })
    } else {
      $http.post("/api/v1/admin/taxons.json", {taxon: taxon}).success(function(data) {
        if(data.success == null) {
          if(data.parent_id == null) {
            taxons.push(data);
          } else {
            parent.descendants.push(data);
          }
          $uibModalInstance.dismiss('cancel');
        } else {
          
        }
      })
    }
  }
}

ubitruAdminControllerModule.controller('CategoriesController', [ '$scope', '$http', '$rootScope', CategoriesController]);
ubitruAdminControllerModule.controller('CategoryController', [ '$scope', '$http', '$rootScope', '$uibModal', CategoryController]);
ubitruAdminControllerModule.controller('AddTaxonModalController', [ '$scope', '$http', '$uibModal', '$uibModalInstance', 'taxon', 'taxons', 'parent', AddTaxonModalController]);
