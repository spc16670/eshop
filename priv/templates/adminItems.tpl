  <div class="container-fluid">
    <!-- Items -->
    <div class="row eshop-top-margin">
      <div class="col-sm-12">

	<div class="panel panel-default">

	  <div class="panel-heading">
	    <h4 class="pull-left">Items</h4>
 	    <div class="dropdown pull-right">
	      <button class="btn btn-default dropdown-toggle" type="button" id="dropdownMenu1" data-toggle="dropdown">
		Category
		<span class="caret"></span>
	      </button>
	      <ul class="dropdown-menu" role="menu" aria-labelledby="dropdownMenu1">
		<li role="presentation"><a role="menuitem" tabindex="-1" href="#">Action</a></li>
		<li role="presentation"><a role="menuitem" tabindex="-1" href="#">Another action</a></li>
		<li role="presentation"><a role="menuitem" tabindex="-1" href="#">Something else here</a></li>
		<li role="presentation" class="divider"></li>
		<li role="presentation"><a role="menuitem" tabindex="-1" href="#">Separated link</a></li>
	      </ul>
	    </div> 
	    <div class="clearfix"></div>
	  </div>

	  <ul class="list-group">
            <li class="list-group-item" ng-if="items.length == 0">
	      {[ itemsMessage ]}
	    </li>
          </ul>

	  <table class="table table-bordered table-hover table-condensed">
	    <tr style="font-weight: bold">
	      <td style="width:20%">Name</td>
	      <td style="width:40%">Description</td>
	      <td style="width:20%">Edit</td>
	    </tr>
	    <tr ng-repeat="item in items">

	      <td>
		<!-- editable username (text with validation) -->
	       <span editable-text="item.data.name" e-name="name" e-form="rowform" onbeforesave="inputValid($data, item.data.id)" e-required>
                {[ item.data.name ]}
	        </span>
	      </td>

	      <td>
	        <!-- editable status (select-local) -->
	        <span editable-textarea="item.data.description" e-name="description" e-rows="7" e-style="width:100%;overflow:auto;resize:none" e-form="rowform" onbeforesave="inputValid($data, item.data.id)" e-required>
	        {[ item.data.description ]}
	        </span>
	      </td>

	      <td style="white-space: nowrap">
	        <!-- form -->
	        <form editable-form name="rowform" onbeforesave="updateItem($data, item.data.id)" ng-show="rowform.$visible" class="form-buttons form-inline" shown="false">
	          <button type="submit" ng-disabled="rowform.$waiting" class="btn btn-primary">
                    Save
	          </button>
	          <button type="button" ng-disabled="rowform.$waiting" ng-click="rowform.$cancel()" class="btn btn-default">
                    Cancel
	          </button>
	        </form>

                <div class="buttons" ng-show="!rowform.$visible">
                  <button class="btn btn-primary" ng-click="rowform.$show()">Modify</button>
                  <button class="btn btn-danger" ng-click="removeItem($index)">Remove</button>
                </div>  

	      </td>
	    </tr>
	  </table>





          <ul class="list-group">
           <li class="list-group-item" ng-show="showAddItemPanel">
	      <div>
		<form id="formAddItem" name="formAddItem" class="form-group" role="form" novalidate ng-submit="addItem()">
	        <div class="row">
	          <div class="col-sm-3">
		    <input id="itemName" class="form-control" name="itemName" placeholder="Name" ng-model="newItem.name" required> 
	          </div>
	          <div class="col-sm-6"> 
		    <textarea id="itemDescription" class="form-control" name="itemDescription" style="resize:none" placeholder="Description" ng-model="newItem.description" required rows="5"></textarea> 
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
	    <button type="button" ng-click="showAddItemPanel = ! showAddItemPanel" class="btn btn-primary pull-left">
	      Add Item
	    </button>
	    <pagination class="pagination-panel pull-right" total-items="bigTotalItems" ng-model="bigCurrentPage" max-size="maxSize" boundary-links="true"></pagination>
	    <div class="clearfix"></div>
	  </div>

  
        </div>
      </div>
    </div>
    
  </div>

