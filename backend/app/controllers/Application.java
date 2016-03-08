package controllers;

import java.util.List;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.node.ObjectNode;

import models.Event;
import models.User;
import play.libs.Json;
import play.mvc.BodyParser;
import play.mvc.Controller;
import play.mvc.Result;

public class Application extends Controller {
    
    public static Result index() {
    	User.create("User1", "englisch");
    	User.create("User2", "deutsch");
        return redirect("/index.html");
    }
    
   public static Result getUsers() {
    	List<User> users = User.find.all(); 
    	return ok(Json.toJson(users));
    }
    
    public static Result getUser(String id) {
    	User user = User.find.byId(Long.parseLong(id));
    	return ok(Json.toJson(user));
    }
    
    public static Result getEvents() {
    	//read GET Parameters
    	String lang = request().getQueryString("lang");
    	String from = request().getQueryString("from");
    	String to = request().getQueryString("to");
    	String limit = request().getQueryString("limit");
    	
    	List<Event> events;
    	
    	if(to!=null){
    		events = Event.getEvents(from, to);
    	}
    	else{
    		events = Event.getEvents(from); 
    	}
    	
    	if(limit!=null && events.size()>0){
    		return ok(Json.toJson(events.subList(0, Integer.parseInt(limit))));
    	}
    	
    	return ok(Json.toJson(events));
    }
    
    
    public static Result getEvent(String id) {
    	Event event = Event.find.byId(Long.parseLong(id)); 
    	return ok(Json.toJson(event));
    }
    
    @BodyParser.Of(BodyParser.Json.class)
    public static Result postUser() {
    	User user=null;
    	JsonNode json = request().body().asJson();
    	ObjectNode status = Json.newObject();
    	//Create when no id is delivered
    	if(json.get("id")==null){
    		//check if User already exists
    		if(User.find.where().eq("name", json.get("name").textValue()).findRowCount()>0){
    			status.put("status", "taken");
    			return badRequest(status);
    		}
    		 user = User.create(json.get("name").textValue(), json.get("lang").textValue());
    		 status.put("status", "done");
    		 return ok(status);
    	}
    	//Update when id is delivered
    	user = User.update(json.get("id").textValue(), json.get("lang").textValue());
    	status.put("status", "updated");   		
    	return ok(status);
    }
}
