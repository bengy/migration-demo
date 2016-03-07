package controllers;

import java.util.List;

import models.Event;
import models.ModellUser;
import play.libs.Json;
import play.mvc.Controller;
import play.mvc.Result;

public class Application extends Controller {
    
    public static Result index() {
        return redirect("/index.html");
    }
    
    public static Result users() {
    	List<ModellUser> users = ModellUser.find.all(); 
    	return ok(Json.toJson(users));
    }
    
    public static Result events() {
    	List<Event> events = Event.find.all(); 
    	return ok(Json.toJson(events));
    }
}
