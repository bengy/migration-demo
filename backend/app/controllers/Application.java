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
    
	public static final String STATUS = "status";
	
    public static Result index() {
        return redirect("/index.html");
    }
    
   public static Result getUsers() {
    	List<User> users = User.find.all(); 

    	return ok(Json.toJson(users));
    }
    
    public static Result getUser(Long id) {
    	User user = User.find.byId(id);
    	return ok(Json.toJson(user));
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
    			status.put(STATUS, "taken");
    			return badRequest(status);
    		}
    		 user = User.create(json.get("name").textValue(), json.get("lang").textValue());
    		 status.put(STATUS, "done");
    		 status.put("id", user.getUserId());
    		 return ok(status);
    	}
    	//Update when id is delivered
    	if(User.find.byId(Long.parseLong(json.get("id").textValue())) != null){
	    	user = User.update(json.get("id").textValue(), json.get("lang").textValue());
	    	status.put(STATUS, "updated");
	    	return ok(status);
    	}else{
    		status.put(STATUS, "null");
	    	return ok(status);
    	}
    }
    
    public static Result deleteUser(Long id){
    	ObjectNode status = Json.newObject();
    	User user = User.find.byId(id);
    	if(user!=null){
    		user.delete();
    		status.put(STATUS, "deleted");
    	}
    	else{
        	status.put(STATUS, "null");
    	}
    	return ok(status);
    }
    
    @BodyParser.Of(BodyParser.Json.class)
    public static Result postEvent() {
    	Event event=null;
    	JsonNode json = request().body().asJson();
    	ObjectNode status = Json.newObject();
    	String name = json.get("name").textValue();
    	String desc = json.get("desc").textValue();
    	Long from = Long.parseLong(json.get("from").textValue());
    	Long to = Long.parseLong(json.get("to").textValue());
    	//Create when no id is delivered
    	if(json.get("id")==null){
				event = Event.create(name, desc, from, to);
    			status.put(STATUS, "done");
    			status.put("eventId", event.getEventId());
    			return ok(status);
    	}
    	//Update when id is delivered
    	Long id = Long.parseLong(json.get("id").textValue());
    	if(Event.find.byId(id) != null){
				event = Event.update(id, name, desc, from, to);
				status.put(STATUS, "updated");   	
		    	return ok(status);
    	}
    	else{
    		status.put(STATUS, "null");   	
	    	return ok(status);
    	}
    }
   
    public static Result getEvents(String lang, Long from, Long to, int limit) {
    	List<Event> events = null;
    	
    	if(from!=0 && to!=0){
			events = Event.getEvents(from, to);
    	}
    	
    	if(from!=0 && to==0){
			events = Event.getEvents(from);
    	}
    	
    	if(from==0 && to==0){
			events = Event.getEvents();
		} 
    	
    	if(limit!=0 && events!=null && events.size()>0){
    		return ok(Json.toJson(events.subList(0, limit)));
    	}
    	
    	return ok(Json.toJson(events));
    }
    
    public static Result getEvent(Long id) {
    	Event event = Event.find.byId(id); 	
    	return ok(Json.toJson(event));
    }
    
    public static Result deleteEvent(Long id){
    	ObjectNode status = Json.newObject();
    	Event event = Event.find.byId(id);
    	if(event!=null){
    		event.delete();
    		status.put(STATUS, "deleted");
    	}
    	else{
        	status.put(STATUS, "null");
    	}
    	return ok(status);
    }
    
    
}
