  <div class="container-fluid">
    <!-- Existing Categories -->
    <div class="row eshop-top-margin">
      <div class="col-sm-12">
        <div class="panel panel-default" cg-busy="promiseCategories">

          <div class="panel-heading">
            <h3 >Categories</h3>
          </div>

          <ul class="list-group">
	    <!-- No categories available -->
            <li class="list-group-item" ng-if="categories.length == 0">
	      {[ categoriesMessage ]}
	    </li>
          </ul>


	  <table class="table table-bordered table-hover table-condensed">
	    <tr style="font-weight: bold">
	      <td style="width:20%">Name</td>
	      <td style="width:40%">Description</td>
	      <td style="width:20%">Edit</td>
	    </tr>
	    <tr ng-repeat="category in categories">

	      <td>
		<!-- editable username (text with validation) -->
	       <span editable-text="category.data.name" e-name="name" e-form="rowform" onbeforesave="inputValid($data, category.data.id)" e-required>
                {[ category.data.name ]}
	        </span>
	      </td>

	      <td>
	        <!-- editable status (select-local) -->
	        <span editable-textarea="category.data.description" e-name="description" e-rows="7" e-style="width:100%;overflow:auto;resize:none" e-form="rowform" onbeforesave="inputValid($data, category.data.id)" e-required>
	        {[ category.data.description ]}
	        </span>
	      </td>

	      <td style="white-space: nowrap">
	        <!-- form -->
	        <form editable-form name="rowform" onbeforesave="updateCategory($data, category.data.id)" ng-show="rowform.$visible" class="form-buttons form-inline" shown="false">
	          <button type="submit" ng-disabled="rowform.$waiting" class="btn btn-primary">
                    Save
	          </button>
	          <button type="button" ng-disabled="rowform.$waiting" ng-click="rowform.$cancel()" class="btn btn-default">
                    Cancel
	          </button>
	        </form>

                <div class="buttons" ng-show="!rowform.$visible">
                  <button class="btn btn-primary" ng-click="rowform.$show()">Modify</button>
                  <button class="btn btn-danger" ng-click="removeCategory($index)">Remove</button>
                </div>  

	      </td>
	    </tr>
	  </table>





         <ul class="list-group">
           <li class="list-group-item" ng-show="showAddCategoryItemPanel">
	      <div>
		<form id="formAddCategory" name="formAddCategory" class="form-group" role="form" novalidate ng-submit="addCategory()">
	        <div class="row">
	          <div class="col-sm-3">
		    <input id="categoryName" class="form-control" name="categoryName" placeholder="Name" ng-model="newCategory.name" required> 
	          </div>
	          <div class="col-sm-6"> 
		    <textarea id="categoryDescription" class="form-control" name="categoryDescription" style="resize:none" placeholder="Description" ng-model="newCategory.description" required rows="5"></textarea> 
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

