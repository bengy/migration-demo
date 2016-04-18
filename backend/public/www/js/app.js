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
    this.deleteEventById = bind(this.deleteEventById, this);
    this.getEventById = bind(this.getEventById, this);
    this.saveEvent = bind(this.saveEvent, this);
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

  EventService.prototype.saveEvent = function(e) {
    var eventToSave;
    eventToSave = {
      name: e.name,
      desc: e.desc,
      to: e.to.valueOf(),
      from: e.from.valueOf()
    };
    if (e.eventId != null) {
      eventToSave["eventId"] = "" + e.eventId;
    }
    console.log("Saving: ", eventToSave);
    return this.http.post("/api/v1/event", eventToSave).then((function(_this) {
      return function(res) {
        var ev, i, len, ref, results;
        console.log("Saved: ", res.data);
        if (res.status === 200 && res.data.status === "done") {
          eventToSave.eventId = res.data.eventId;
          _this.eventList.push(eventToSave);
          return;
        }
        if (res.status === 200 && res.data.status === "updated") {
          ref = _this.eventList;
          results = [];
          for (i = 0, len = ref.length; i < len; i++) {
            ev = ref[i];
            if (ev.eventId = e.eventId) {
              ev.name = e.name;
              ev.desc = e.desc;
              ev.to = e.to;
              results.push(ev.from = e.from);
            } else {
              results.push(void 0);
            }
          }
          return results;
        }
      };
    })(this));
  };

  EventService.prototype.getEventById = function(id) {
    return this.http.get("/api/v1/event/" + id).then(function(res) {
      var e;
      e = res.data;
      e.to = new Date(e.to);
      e.from = new Date(e.from);
      return e;
    });
  };

  EventService.prototype.deleteEventById = function(id) {
    return this.http["delete"]("/api/v1/event/" + id).then((function(_this) {
      return function(res) {
        if (res.status === 200 && res.data.status === "deleted") {
          return _this.eventList = _this.eventList.filter(function(e) {
            return e.eventId !== id;
          });
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
    var eventId, today;
    this.eventService = eventService;
    this.location = location;
    this.scope = scope1;
    this.clickedDelete = bind(this.clickedDelete, this);
    this.clickedSave = bind(this.clickedSave, this);
    this.clickedCancel = bind(this.clickedCancel, this);
    this.scope.pageClass = "event-detail-page";
    eventId = this.location.search().eventId;
    if (eventId != null) {
      this.eventService.getEventById(eventId).then((function(_this) {
        return function(e) {
          _this.editEvent = e;
          return console.log("Editing: ", _this.editEvent);
        };
      })(this));
    } else {
      console.log("Create new event.");
      today = new Date();
      today.setSeconds(0);
      today.setMilliseconds(0);
      this.editEvent = {
        name: "",
        desc: "",
        from: today,
        to: today
      };
    }
    return;
  }

  EventDetailController.prototype.clickedCancel = function() {
    return this.location.path("/");
  };

  EventDetailController.prototype.clickedSave = function() {
    this.eventService.saveEvent(this.editEvent);
    return this.location.path("/");
  };

  EventDetailController.prototype.clickedDelete = function() {
    return this.eventService.deleteEventById(this.editEvent.eventId).then((function(_this) {
      return function() {
        return _this.location.path("/");
      };
    })(this));
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
      this.clickedEditEvent = bind(this.clickedEditEvent, this);
      this.clickedNewEvent = bind(this.clickedNewEvent, this);
      console.log("Init event page");
      return;
    }

    EventController.prototype.clickedNewEvent = function() {
      console.log("Clicked new event");
      return this.location.path("/event-detail");
    };

    EventController.prototype.clickedEditEvent = function(e) {
      console.log("Clicked edit:", e);
      return this.location.url("/event-detail?eventId=" + e.eventId);
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
