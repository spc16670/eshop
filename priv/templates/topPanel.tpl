
   <!-- Fixed navbar -->
   <div class="navbar navbar-default navbar-fixed-top" role="navigation">
     <div class="container">
       <div class="navbar-header" ng-click="visible('showShop')">
         <button type="button" class="navbar-toggle" data-toggle="collapse" data-target=".navbar-collapse">
           <span class="sr-only">Toggle navigation</span>
           <span class="icon-bar"></span>
           <span class="icon-bar"></span>
           <span class="icon-bar"></span>
         </button>
         <a class="navbar-brand" href="#">Lamazone</a>
       </div> <!--./navbar-header-->

       <div class="navbar-collapse collapse" ng-switch on="currentUser.role">

         <ul class="nav navbar-nav">
           <li><a href="#about">About</a></li>
           <li><a href="#contact">Contact</a></li>
         </ul>

	 <!-- The Admin Landing - always logged in -->
         <ul class="nav navbar-nav navbar-right" ng-switch-when="admin">
           <li ng-class="{ active: toggler.showAdmin }">
               <a href="#" ng-click="visible('showAdmin')">Administration</a>
           </li> 
           <li class="dropdown">
             <a href="#" class="dropdown-toggle" id="btn-account" data-toggle="dropdown">
	      {[ currentUser.shopper.fname ]}<b class="caret"></b>
	     </a>
               <ul class="dropdown-menu">
		 <li >
		   <a id="btn-personal" href="#" ng-click="visible('showPersonal')">Personal Information</a>
		 </li>
		 <li class="divider"></li>
		 <li ng-if="currentUser.isLogged">
		   <a href="#" ng-click="logout()">Log Out</a>
		 </li>
               </ul>
           </li>

           <li ng-class="{ active: toggler.showQueue }">
             <a href="#" ng-click="visible('showQueue')">Queue</a>
           </li>

           <li ng-class="{ active: toggler.showBasket }">
             <a href="#" ng-click="visible('showBasket')">Basket</a>
           </li>
         </ul>


	 <!-- The Staff Landing - always logged in -->
         <ul class="nav navbar-nav navbar-right" ng-switch-when="staff">
           <li class="dropdown" ng-if="currentUser.isLogged">
             <a ng-if="currentUser.isLogged" href="#" class="dropdown-toggle" id="btn-account" data-toggle="dropdown">
	      {[ currentUser.shopper.fname ]}<b class="caret"></b>
	     </a>
               <ul class="dropdown-menu">
		 <li>
		   <a id="btn-personal" href="#" ng-click="visible('showPersonal')">Personal Information</a>
		 </li>
		 <li class="divider"></li>
		 <li>
		   <a href="#" ng-click="logout()">Log Out</a>
		 </li>
               </ul>
           </li>
           <li ng-class="{ active: toggler.showBasket }">
             <a href="#" ng-click="visible('showBasket')">Basket</a>
           </li>
           <li ng-class="{ active: toggler.showQueue }">
             <a href="#" ng-click="visible('showQueue')">Queue</a>
           </li>
         </ul>

	 <!-- The Default Landing -->
         <ul class="nav navbar-nav navbar-right" ng-switch-default>
           <li ng-class="{ active: toggler.showRegister }" ng-if="!currentUser.isLogged">
             <a id="btn-signup" href="#" ng-click="visible('showRegister')">Sign Up</a>
           </li>
           <li ng-class="{ active: toggler.showLogin }" ng-if="!currentUser.isLogged">
             <a id="btn-signup" href="#" ng-click="visible('showLogin')">Log In</a>
           </li>

           <li class="dropdown" ng-if="currentUser.isLogged">
             <a ng-if="currentUser.isLogged" href="#" class="dropdown-toggle" id="btn-account" data-toggle="dropdown">
	      {[ currentUser.shopper.fname ]}<b class="caret"></b>
	     </a>
               <ul class="dropdown-menu">
		 <li ng-if="currentUser.isLogged">
		   <a id="btn-personal" href="#" ng-click="visible('showPersonal')">Personal Information</a>
		 </li>
		 <li class="divider"></li>
		 <li ng-if="currentUser.isLogged">
		   <a href="#" ng-click="logout()">Log Out</a>
		 </li>
               </ul>
           </li>
           <li ng-class="{ active: toggler.showBasket }">
             <a href="#" ng-click="visible('showBasket')">Basket</a>
           </li>
         </ul>

       </div><!--/.nav-collapse -->
     </div>
   </div>

