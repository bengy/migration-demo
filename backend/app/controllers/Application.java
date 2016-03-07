package controllers;

import java.util.List;

import models.Event;
import models.Client;
import play.libs.Json;
import play.mvc.Controller;
import play.mvc.Result;

public class Application extends Controller {
    
    public static Result index() {
        return redirect("/index.html");
    }
    
    public static Result users() {
    	List<Client> users = Client.find.all(); 
    	return ok(Json.toJson(users));
    }
    
    public static Result events() {
    	List<Event> events = Event.find.all(); 
    	return ok(Json.toJson(events));
    }
}
