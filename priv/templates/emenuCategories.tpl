  <div class="container-fluid">
    <!-- Existing Categories -->
    <div class="row eshop-top-margin">
      <div class="col-xs-12">
        <div class="panel panel-default">
          <div class="panel-heading">
            <h3 >Categories</h3>
          </div>
          <div class="panel-body">
           Existing Categories
          </div>
          <!-- Table -->
          <table class="table">
            <tr>
              <th>Title</th>
              <th>Description</th>
              <th>Images</th>
              <th></th>
            </tr>
            <!-- Dynamic -->
            <tr eshop-categories>
              <td>Starters</td>
              <td>Try the delicious starters</td>
              <td>Image here</td>
              <td>
                <div>
		  <button type="button" class="btn btn-warning">Modify</button>
		  <button type="button" class="btn btn-danger">Remove</button>
                </div>
              </td>
            </tr>

          </table>

          <div class="panel-footer">
	    <div class="container">
            <div class="pull-right">
	      <button type="button" class="btn btn-primary">Add Categories</button>
	    </div>
            </div>
          </div>
  
        </div>
      </div>
    </div>
    
  </div>

