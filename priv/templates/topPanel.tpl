
   <!-- Fixed navbar -->
   <div class="navbar navbar-default navbar-fixed-top" role="navigation">
     <div class="container">
       <div class="navbar-header">
         <button type="button" class="navbar-toggle" data-toggle="collapse" data-target=".navbar-collapse">
           <span class="sr-only">Toggle navigation</span>
           <span class="icon-bar"></span>
           <span class="icon-bar"></span>
           <span class="icon-bar"></span>
         </button>
         <a class="navbar-brand" href="#">Lamazone</a>
       </div> <!--./navbar-header-->
       <div class="navbar-collapse collapse">

         <ul class="nav navbar-nav">
           <li><a href="#about">About</a></li>
           <li><a href="#contact">Contact</a></li>
         </ul>

         <ul class="nav navbar-nav navbar-right">

           <li ng-class="{ active: toggler.showShoppingView }">
               <a href="#" ng-click="visible('showShoppingView')">Shop</a>
           </li> 

           <li class="dropdown">
             <a ng-if="!currentUser.isLogged" href="#" class="dropdown-toggle" id="btn-account" 
               data-toggle="dropdown">My Account<b class="caret"></b></a>
             <a ng-if="currentUser.isLogged" href="#" class="dropdown-toggle" id="btn-account"
               data-toggle="dropdown">{[ currentUser.shopper.fname ]}<b class="caret"></b></a>
               <ul class="dropdown-menu">
		 <li ng-if="currentUser.isLogged" class="dropdown-header">Administration</li>	
                 <li ng-if="!currentUser.isLogged">
                   <a id="btn-signup" href="#" ng-click="visible('showSignUpView')">Sign Up</a>
                 </li>
		 <li ng-if="currentUser.isLogged">
		   <a id="btn-personal" href="#" ng-click="visible('showPersonalView')">Personal Information</a>
		 </li>
		 <li class="divider"></li>
                 <li ng-if="!currentUser.isLogged">
                   <a id="btn-login" href="#" ng-click="visible('showLoginView')">Log In</a>
                 </li>
		 <li ng-if="currentUser.isLogged">
		   <a href="#" ng-click="logout()">Log Out</a>
		 </li>
               </ul>
           </li>

           <li ng-class="{ active: toggler.showBasketView }">
             <a href="#" ng-click="visible('showBasketView')">Basket</a>
           </li>
         </ul>

       </div><!--/.nav-collapse -->
     </div>
   </div>

