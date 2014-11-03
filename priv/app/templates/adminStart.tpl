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

