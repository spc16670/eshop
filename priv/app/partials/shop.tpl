
  <div class="navbar navbar-default" role="navigation">
    <!-- Search 
    <div class="row">
      <div class="col-md-2 navbar-header">
        <a class="navbar-brand"></a>
      </div>
      <div class="col-md-6">
        <form class="navbar-form" role="search">
            <div class="input-group">
              <input type="text" id="search-input" class="form-control" placeholder="Search">
                <span class="input-group-addon">
                  <a href="">Go</a>
                </span>
            </div>
        </form>
      </div>
      <div class="col-md-4">
        <button type="button" class="btn btn-default navbar-btn">
          Button
        </button>
      </div>
    </div> -->

    <div class="row">
      <!-- Menu -->
      {% include "categories.tpl" %}

      <!-- Main Area -->
      <div class="col-md-10" id="main-area">
        {[ user ]}
        {% include "items.tpl" %}
      </div> <!-- col-md-10 -->
    </div><!-- row -->
  </div><!-- navabar -->
