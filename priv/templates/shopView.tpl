
  <div class="navbar navbar-default" role="navigation">
    <!-- Search -->
    <div class="row">
      <div class="col-md-2 navbar-header">
        <a class="navbar-brand"></a>
      </div>
      <div class="col-md-6">
        <form class="navbar-form" role="search">
          <!--<div> -->
            <div class="input-group">
              <input type="text" id="search-input" class="form-control" placeholder="Search">
                <span class="input-group-addon">
                  <a href="">Go</a>
                </span>
            </div><!-- input-group -->
         <!-- </div> form-group -->
        </form>
      </div><!-- col-md-6 -->
      <div class="col-md-4">
        <button type="button" class="btn btn-default navbar-btn">
          Button
        </button>
      </div><!-- col-md-4 -->
    </div><!-- row -->

    <!-- Menu and Main Display -->
    <div class="row">
      {% include "departments.tpl" %}
      <div class="col-md-10" id="main-area">
        <div>
          <h1>Bootstrap starter template</h1>
          <p><input type="checkbox" checked="yes" id="enable_best"></input>
            Current time (best source): 
	    <span id="time_best">unknown</span>
            <span></span>
	    <span id="status_best">unknown</span>
            <button id="send_best">Send Time</button>
	  </p>
          <p class="lead">Nothing here {[ 'yet' + '!' ]}</p>
          <p class="lead">{[ currentUser ]}</p>
	  <ul>
	    <li ng-repeat"msg in messages">{[ msg ]} </li>
          </ul>
          <input type="test" ng-model="message">
	  <button ng-click="send('test')">Send</button>
        </div>
      </div> <!-- col-md-10 -->
    </div><!-- row -->
  </div><!-- navabar -->
