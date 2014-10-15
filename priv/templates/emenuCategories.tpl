  <div class="container-fluid">
    <!-- Existing Categories -->
    <div class="row eshop-top-margin">
      <div class="col-sm-12">
        <div class="panel panel-default">
          <div class="panel-heading">
            <h3 >Categories</h3>
          </div>

          <!-- Categories Table -->
          <ul class="list-group">
            <li class="list-group-item">
	      <div>
	        <div class="row">
	          <div class="col-sm-2">
		    <h4>Title</h4>
	          </div>
	          <div class="col-sm-4">
		    <h4>Description</h4>
	          </div>
	          <div class="col-sm-3">
		    <h4>Images</h4>
	          </div>
	          <div class="col-sm-3">
		    <h4></h4>
	          </div>
	        </div>
	      </div>
            </li>
	   
	    <!-- No categories available -->
            <li class="list-group-item" ng-if="categories.length == 0">
	      {[ categoriesMessage ]}
	    </li>

	    <!-- List available items -->
            <li class="list-group-item" ng-repeat="category in categories">

	      <div>
                <form name="formHandleCategory-{[ category.data.id ]}" class="form-group" role="form" novalidate>
	        <div class="row">
	          <div class="col-sm-2">
		    <h5>{[ category.data.name ]}</h5>
	          </div>
	          <div class="col-sm-4">
		    <h5>{[ category.data.description ]}</h5>
	          </div>
	          <div class="col-sm-3">
		    <h5></h5>
	          </div>
	          <div class="col-sm-3">
		    <div>
		      <button type="button" class="btn btn-warning" ng-click="handleCategory()">Modify</button>
		      <button type="button" class="btn btn-danger" ng-click="handleCategory()">Remove</button>
                    </div>
	          </div>
	        </div>

              </form>
	      </div>

	    </li>

	    <!-- Add a new item -->
            <li class="list-group-item" ng-show="showAddCategoryItemPanel">
	      <div>
		<form id="formAddCategory" name="formAddCategory" class="form-group" role="form" novalidate ng-submit="addCategory()">
	        <div class="row">
	          <div class="col-sm-2">
		    <input id="categoryName" class="form-control" name="categoryName" placeholder="Name" ng-model="newCategory.name" required> 
	          </div>
	          <div class="col-sm-4"> 
		    <textarea id="categoryDescription" class="form-control" name="categoryDescription" style="resize:none" placeholder="Description" ng-model="newCategory.description" required rows="5"></textarea> 
	          </div>
	          <div class="col-sm-3">
		   Images 
	          </div>
	          <div class="col-sm-3">
		    <div>
		      <button type="submit" class="btn btn-success">Add</button>
                    </div>
	          </div>
	        </div>

		</form>
	      </div>
	    </li>

          </ul>

          <div class="panel-footer">
	    <button type="button" ng-click="showAddCategoryItemPanel = ! showAddCategoryItemPanel" class="btn btn-primary">
	      Add Categories
	    </button>
          </div>
  
        </div>
      </div>
    </div>
    
  </div>

