package controllers;

import java.util.List;

import models.Event;
import models.User;
import play.libs.Json;
import play.mvc.Controller;
import play.mvc.Result;

public class Application extends Controller {
    
    public static Result index() {
    	User.create("User1", "englisch");
    	User.create("User2", "deutsch");
        return redirect("/index.html");
    }
    
   public static Result users() {
    	List<User> users = User.find.all(); 
    	return ok(Json.toJson(users));
    }
    
    public static Result user(String id) {
    	User user = User.find.byId(Long.parseLong(id));
    	return ok(Json.toJson(user));
    }
    
    public static Result events() {
    	List<Event> events = Event.find.all(); 
    	return ok(Json.toJson(events));
    }
    
    public static Result event(String id) {
    	Event event = Event.find.byId(Long.parseLong(id)); 
    	return ok(Json.toJson(event));
    }
}
