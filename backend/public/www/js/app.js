"use strict";
var EventController, EventDetailController, EventService, MainController, app,
  bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

app = angular.module("refugee-app", ["ngRoute", "ngAnimate", "pascalprecht.translate", "ngMaterial"]);

app.config([
  "$routeProvider", "$translateProvider", "$mdThemingProvider", function($routeProvider, $translateProvider, $mdThemingProvider, config) {
    $routeProvider.when("/", {
      templateUrl: "/views/main-page/main.html",
      controller: "MainController",
      controllerAs: "mainCtrl"
    }).when("/event-detail", {
      templateUrl: "/views/event-detail-page/event-detail.html",
      controller: "EventDetailController",
      controllerAs: "eventCtrl"
    }).otherwise({
      redirectTo: "/"
    });
    return $mdThemingProvider.theme('default').primaryPalette('blue').accentPalette('pink');
  }
]);

"use strict";

app = angular.module("refugee-app");

app.service("EventService", EventService = (function() {
  EventService.$inject = ["$http"];

  function EventService(http) {
    this.http = http;
    this.saveNewEvent = bind(this.saveNewEvent, this);
    this.loadEvents = bind(this.loadEvents, this);
    console.log("Init event service");
    this.eventList = [];
    this.loadEvents();
    return;
  }

  EventService.prototype.loadEvents = function() {
    console.log("Loading events");
    return this.http.get("/api/v1/events").then((function(_this) {
      return function(res) {
        _this.eventList = res.data;
        return console.log("Got: ", _this.eventList);
      };
    })(this));
  };

  EventService.prototype.saveNewEvent = function(e) {
    return this.http.post("/api/v1/event", e).then((function(_this) {
      return function(res) {
        console.log("Status: ", res.status);
        console.log("Response: ", res.data);
        if (res.status === 200 && res.data.status === "done") {
          e.id = res.data.eventId;
          return _this.eventList.push(e);
        }
      };
    })(this));
  };

  return EventService;

})());

"use strict";

app = angular.module("refugee-app");

app.controller("EventDetailController", EventDetailController = (function() {
  EventDetailController.$inject = ["EventService", "$location"];

  function EventDetailController(eventService, location) {
    var today;
    this.eventService = eventService;
    this.location = location;
    this.clickedSave = bind(this.clickedSave, this);
    this.clickedCancel = bind(this.clickedCancel, this);
    console.log("Init event detail page");
    today = new Date();
    today.setSeconds(0);
    today.setMilliseconds(0);
    this.editEvent = {
      name: "",
      desc: "",
      from: today,
      to: today
    };
    return;
  }

  EventDetailController.prototype.clickedCancel = function() {
    return this.location.path("/");
  };

  EventDetailController.prototype.clickedSave = function() {
    var eventToSave;
    eventToSave = {
      name: this.editEvent.name,
      desc: this.editEvent.desc,
      to: this.editEvent.to.valueOf(),
      from: this.editEvent.from.valueOf()
    };
    this.eventService.saveNewEvent(eventToSave);
    return this.location.path("/");
  };

  return EventDetailController;

})());

"use strict";

app = angular.module("refugee-app");

app.component("eventPage", {
  templateUrl: "/views/event-page/event.html",
  bindings: {},
  controller: EventController = (function() {
    EventController.$inject = ["EventService", "$location"];

    function EventController(eventService, location) {
      this.eventService = eventService;
      this.location = location;
      this.clickedNewEvent = bind(this.clickedNewEvent, this);
      console.log("Init event page");
      return;
    }

    EventController.prototype.clickedNewEvent = function() {
      console.log("Clicked new event");
      return this.location.path("/event-detail");
    };

    return EventController;

  })()
});

"use strict";

app = angular.module("refugee-app");

app.controller("MainController", MainController = (function() {
  MainController.$inject = ["$anchorScroll", "$location", "$timeout", "$log", "$scope", "$http"];

  function MainController(anchorScroll, location, timeout, log, scope, http) {
    this.anchorScroll = anchorScroll;
    this.location = location;
    this.timeout = timeout;
    this.log = log;
    this.scope = scope;
    this.http = http;
    console.log("Init main page");
    return;
  }

  return MainController;

})());
