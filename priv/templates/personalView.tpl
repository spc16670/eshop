
  <div class="navbar navbar-default" role="navigation">

    <!-- Menu and Main Display -->
    <div class="row">

      <div class="col-md-2 sidebar">
        <ul class="nav nav-sidebar">
          <!--<li class="active"><a href="#">About you</a></li>-->
          <li><p>About you</p></li>
        </ul>
      </div>


      <div class="col-md-10" id="about-you">

        <div>
          <h1>Your details:</h1>
          <p class="lead">First name: {[ currentUser.fname ]}</p>
          <p class="lead">Last name: {[ currentUser.lname ]}</p>
	  <ul>
	    <li ng-repeat"msg in messages">{[ msg ]} </li>
          </ul>
	  <button ng-click="send('test')">Send</button>
        </div>

      </div> <!-- col-md-10 -->
    </div><!-- row -->
  </div><!-- navabar -->
