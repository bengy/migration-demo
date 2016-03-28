var EventController, EventDetailController, EventService, MainController, TabService, app,
  bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

angular.module("mdExtension", []).directive("mdeButtonRipple", function() {
  var directiveDefinitionObject;
  return directiveDefinitionObject = {
    restrict: "A",
    scope: {
      mdeButtonRipple: "&"
    },
    link: function(scope, elem, attrs, ngModel) {
      var buttonChildrenRef, buttonRef, handleClick;
      buttonRef = elem;
      buttonChildrenRef = elem.children();
      handleClick = function() {
        var buttonClone, buttonColor;
        buttonColor = $(buttonRef).css("background-color");
        buttonClone = $(buttonRef).clone();
        buttonClone.children().remove();
        $("body").append(buttonClone);
        $(buttonClone).animate({
          scale: 30,
          backgroundColor: "#FFF"
        }, {
          easing: "swing",
          duration: 200,
          step: function(now, fx) {
            return $(buttonClone).css("transform", "scale(" + now + ")");
          },
          complete: function() {
            setTimeout(function() {
              return scope.$applyAsync(function() {
                scope.mdeButtonRipple();
                $(buttonClone).detach();
              });
            }, 300);
          }
        });
      };
      return elem.on("click", handleClick);
    }
  };
}).animation(".info-panel", function() {
  return {
    enter: function(elem, done) {
      var autoHeight;
      autoHeight = elem.css("height", "auto").height();
      elem.css("height", 0);
      elem.animate({
        height: autoHeight
      }, 500, "easeInOutQuart", done);
    },
    leave: function(elem, done) {
      elem.animate({
        height: 0
      }, 200, "easeInOutQuart", function() {
        var destinationHeight, ref;
        destinationHeight = $("#commenter").height();
        $("html").height(destinationHeight);
        if ((typeof self !== "undefined" && self !== null ? (ref = self.port) != null ? ref.emit : void 0 : void 0) != null) {
          self.port.emit("resize", 0);
        }
        return done();
      });
    }
  };
});

"use strict";

app = angular.module("refugee-app", ["ngRoute", "ngAnimate", "pascalprecht.translate", "ngMaterial", "mdExtension"]);

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
          _this.eventList.push(e);
        }
      };
    })(this));
  };

  return EventService;

})());

"use strict";

app = angular.module("refugee-app");

app.service("TabService", TabService = (function() {
  function TabService() {
    this.getCurrent = bind(this.getCurrent, this);
    this.setCurrent = bind(this.setCurrent, this);
    this.tabsMap = {};
    return;
  }

  TabService.prototype.setCurrent = function(tabsId, index) {
    return this.tabsMap[tabsId] = index;
  };

  TabService.prototype.getCurrent = function(tabsId) {
    return this.tabsMap[tabsId] || 0;
  };

  return TabService;

})());

"use strict";

app = angular.module("refugee-app");

app.controller("EventDetailController", EventDetailController = (function() {
  EventDetailController.$inject = ["EventService", "$location", "$scope"];

  function EventDetailController(eventService, location, scope1) {
    var today;
    this.eventService = eventService;
    this.location = location;
    this.scope = scope1;
    this.clickedSave = bind(this.clickedSave, this);
    this.clickedCancel = bind(this.clickedCancel, this);
    console.log("Init event detail page");
    this.scope.pageClass = "event-detail-page";
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
  MainController.$inject = ["$anchorScroll", "$location", "$timeout", "$log", "$scope", "$http", "TabService"];

  function MainController(anchorScroll, location, timeout, log, scope1, http, tabService) {
    this.anchorScroll = anchorScroll;
    this.location = location;
    this.timeout = timeout;
    this.log = log;
    this.scope = scope1;
    this.http = http;
    this.tabService = tabService;
    console.log("Init main page");
    this.scope.pageClass = "main-page";
    this.currentTab = this.tabService.getCurrent('main') || 1;
    return;
  }

  return MainController;

})());
