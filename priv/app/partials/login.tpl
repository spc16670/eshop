
  <div class="navbar navbar-default" role="navigation">
    <!-- LOGIN -->
    <div class="row eshop-top-margin">
      <div class="col-md-2">
      </div>
      <div class="col-md-8">

        <div class="panel">
          <!--<div class="panel-heading">Panel heading without title</div>-->
          <div class="panel-body">

            <div class="row">
              <!--
	      <div class="col-md-3">
                <div class="panel">
		  <h2>Signing in</h2>
 		  <div class="panel">
		    <div>signing in</div>
		  </div>
	        </div>
              </div>
              
	      <div class="col-md-9">
              -->
                <form class="form-signin" name="loginForm" role="form" ng-submit="submit()">
                  <input type="email" class="form-control" ng-model="login.email" placeholder="Email address" required autofocus>
                  <input type="password" class="form-control" ng-model="login.password" placeholder="Password" required>
                  <!--<label class="checkbox">
                    <input type="checkbox" value="remember-me"> Remember me
                  </label> -->
                  <button class="btn btn-lg btn-primary btn-block" ng-model="login" type="submit">Sign in</button>
		  <a href="">Forgot password?</a>
		  <div id="loginStatus" style="height:30px">
                    <div ng-repeat="alert in alerts" close="closeAlert($index)">
                      <div class="alert alert-{[ alert.type ]} alert-dismissable">
                        <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
                        <strong></strong> {[ alert.msg ]}
                      </div>
                    </div>
                  </div>
                </form>
             <!-- </div> -->

            </div>

          </div>
	</div>

      </div>
      <div class="col-md-2">
      </div>
    </div><!-- row -->
  </div><!-- navabar -->
