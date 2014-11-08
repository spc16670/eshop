
   <!-- Fixed navbar -->
   <div class="navbar navbar-default navbar-fixed-top" role="navigation">
     <div class="container">
       <div class="navbar-header" ui-sref="shell.shop.offers">
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

	 <!-- The Default Landing -->
         <ul class="nav navbar-nav navbar-right">
           <li ng-class="{ active: toggler.showAdmin }" ng-if="user.access > 3">
               <!--<a href="#" ng-click="visible('showAdmin')">Administration</a>-->
               <a href="#" ui-sref="admin.start">Administration</a>
           </li> 
           <li ng-class="{ active: toggler.showRegister }" ng-if="!user.isLogged">
             <a id="btn-signup" href="#" ui-sref="shell.register">Sign Up</a>
           </li>
           <li ng-class="{ active: toggler.showLogin }" ng-if="!user.isLogged">
             <a id="btn-signup" ui-sref="shell.login">Log In</a>
           </li>

           <li class="dropdown" ng-if="user.isLogged">
             <a ng-if="user.isLogged" href="#" class="dropdown-toggle" id="btn-account" data-toggle="dropdown">
	      {[ user.shopper.fname ]}<b class="caret"></b>
	     </a>
               <ul class="dropdown-menu">
		 <li ng-if="user.isLogged">
		   <a id="btn-personal" href="#" ng-click="visible('showPersonal')">Personal Information</a>
		 </li>
		 <li class="divider"></li>
		 <li ng-if="user.isLogged">
		   <a href="#" ng-click="logout()">Log Out</a>
		 </li>
               </ul>
           </li>
           <li ng-class="{ active: toggler.showBasket }">
             <a ui-sref="shell.basket">Basket</a>
           </li>
         </ul>

       </div><!--/.nav-collapse -->
     </div>
   </div>

