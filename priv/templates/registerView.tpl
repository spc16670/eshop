  
  <div id="registration_div" class="navbar navbar-default" role="navigation">
    <div class="container">
      <div >
        <form id="signUpForm" name="signUpForm" class="form-group" role="form" novalidate ng-submit="submit()">
          <div class="row eshop-top-margin"></div>

          <div class="row">	
            <div class="col-md-6">

	      <div class="control-group" ng-class="{'has-error' : signUpForm.fname.$invalid && signUpForm.fname.$dirty, 'has-success' :  signUpForm.fname.$invalid && signUpForm.fname.$dirty}">
	        <label class="control-label">First Name</label>
	          <div class="controls">
	            <div class="input-prepend">
		      <input type="text" class="form-control" id="fname" name="fname" ng-model="newShopper.fname" required placeholder="First Name" show-errors="pushAlerts()">
	            </div>
	          </div>
	      </div>

	      <div class="control-group" ng-class="{'has-error' : signUpForm.lname.$invalid && signUpForm.lname.$dirty, 'has-success' :  signUpForm.lname.$invalid && signUpForm.lname.$dirty}"> 
	        <label class="control-label">Last Name</label>
	          <div class="controls">
	            <div class="input-prepend">
		      <input type="text" class="form-control" id="lname" name="lname" placeholder="Last Name" ng-model="newShopper.lname" required show-errors="pushAlerts()">
	            </div>
	          </div>
	      </div>

	      <div class="control-group" ng-class="{'has-error' : signUpForm.addressline1.$invalid && signUpForm.addressline1.$dirty, 'has-success' :  signUpForm.addressline1.$invalid && signUpForm.addressline1.$dirty}">
	        <label class="control-label">Address Line 1</label>
	          <div class="controls">
	            <div class="input-prepend">
		      <input type="text" class="form-control" id="addressline1" name="addressline1" placeholder="Address Line 1" ng-model="newAddress.addressline1" required show-errors="pushAlerts()">
	            </div>
	          </div>	
	      </div>

              <div class="control-group">
                <label class="control-label">Address Line 2</label>
                  <div class="controls">
                    <div class="input-prepend">
                      <input type="text" class="form-control" id="addressline2" name="addressline2" placeholder="Address Line 2" ng-model="newAddress.addressline2">
                    </div>
                  </div>
              </div>

              <div class="control-group" ng-class="{'has-error' : signUpForm.postcode.$invalid && signUpForm.postcode.$dirty, 'has-success' :  signUpForm.postcode.$invalid && signUpForm.postcode.$dirty}">
                <label class="control-label">Postcode</label>
                  <div class="controls">
                    <div class="input-prepend">
                      <input type="text" class="form-control" id="postcode" name="postcode" placeholder="Postcode" ng-model="newAddress.postcode" required show-errors="pushAlerts()">
                    </div>
                  </div>
              </div>

              <div class="control-group" ng-class="{'has-error' : signUpForm.city.$invalid && signUpForm.city.$dirty, 'has-success' :  signUpForm.city.$invalid && signUpForm.city.$dirty}">
                <label class="control-label">City / Town</label>
                  <div class="controls">
                    <div class="input-prepend">
                      <input type="text" class="form-control" id="city" name="city" placeholder="City / Town" ng-model="newAddress.city" required show-errors="pushAlerts()">
                    </div>
                  </div>
              </div>

	      <div class="control-group">
	        <label class="control-label">Gender</label>
	          <div class="controls">
		    <div class="row">
		      <div class="content">
		        <div class="col-md-3">
			  <div class="radio">
			    <label>
			      <input type="radio" name="female" value="f" ng-model="newShopper.gender" ng-init="newShopper.gender='f'" required>
			        Female
			    </label>
			  </div>
		        </div>
		        <div class="col-md-3">
			  <div class="radio">
			    <label>
			     <input type="radio" name="male" value="m" ng-model="newShopper.gender" required>
			       Male
			    </label>
			  </div>
		        </div>
		        <div class="col-md-3"></div>
	              </div><!-- ./content -->
		    </div>
	          </div>
	      </div>

	    </div> <!--col-md-6-->

	    <div class="col-md-6">

              <div class="control-group" ng-class="{'has-error' : signUpForm.email.$invalid && signUpForm.email.$dirty, 'has-success' :  signUpForm.email.$invalid && signUpForm.email.$dirty}">
                <label class="control-label">Email</label>
                  <div class="controls">
                    <div class="input-prepend">
                      <input type="email" class="form-control" id="email" name="email" placeholder="Email" ng-model="newUser.email" required show-errors="pushAlerts()">
                    </div>
                  </div>
              </div>

	      <div class="control-group" ng-class="{'has-error' : signUpForm.password.$invalid && signUpForm.password.$dirty , 'has-success' :  signUpForm.password.$invalid && signUpForm.password.$dirty}">
	        <label class="control-label">Password</label>
	          <div class="controls">
	            <div class="input-prepend">
		      <input type="Password" id="passwd" class="form-control" name="password" 
		        placeholder="Password" ng-model="newUser.password" ng-minlength='6' required show-errors="pushAlerts()">
		      <p class="help-block" ng-show="signUpForm.password.$error.minlength || signUpForm.password.$invalid">Password must be at least 6 characters</p>
	            </div>
	          </div>
	      </div>

	      <div class="control-group" ng-class="{'has-error' : signUpForm.confirm_password.$invalid && signUpForm.confirm_password.$dirty, 'has-success' :  signUpForm.confirm_password.$invalid && signUpForm.confirm_password.$dirty}">
	        <label class="control-label">Confirm Password</label>
	          <div class="controls">
	            <div class="input-prepend">
		      <input type="Password" id="confirm_password" class="form-control" name="confirm_password" 
		        placeholder="Re-enter Password" ng-model="newUser.password_verify" password-verify="newUser.password" required show-errors="pushAlerts()">
	            </div>
	          </div>
	      </div>
	
	      <!-- ALERTS -->
              <div class="control-group">
                <h2>Signing up</h2>
		  <div id="signUpStatus" style="height:58px">
		    <div ng-repeat="alert in alerts" close="closeAlert($index)">
		      <div class="alert alert-{[ alert.type ]} alert-dismissable">
  		        <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
  		          <strong></strong> {[ alert.msg ]}
		      </div>
		    </div>
                  </div>   
              </div>

              <div class="pull-right">
                <div class="control-group">
                  <label class="control-label" for="input01"></label>
                    <div class="controls">
                      <button type="submit" class="btn btn-success" rel="tooltip" title="Submits the form data to the server" ng-disabled="signUpForm.$invalid">Create My Account</button>
                    </div> <!-- controls -->
                </div> <!-- control-group -->
	      </div> <!-- pull-right -->

	    </div> <!-- ./col-md-6 -->
          </div><!-- row -->

          <div class="row">
          </div> <!-- row -->
        </form>
      </div>
    </div>
  </div>
