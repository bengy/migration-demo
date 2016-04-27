package controllers;

import java.util.List;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.node.ObjectNode;

import models.Event;
import models.Info;
import models.Request;
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

//#############USER API################################        
    
   public static Result getUsers() {
    	List<User> users = User.find.all();

    	return ok(Json.toJson(users));
    }

    public static Result getUser(Long id) {
    	User user = null;
    	user = User.find.byId(id);
    	
    	if(user!=null){
    		return ok(Json.toJson(user));
    	}
    	
    	ObjectNode status = Json.newObject();
    	status.put(STATUS, "null");
    	return ok(status);
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

//#############EVENT API################################    
    
    @BodyParser.Of(BodyParser.Json.class)
    public static Result postEvent() {
    	Event event=null;
    	JsonNode json = request().body().asJson();
    	ObjectNode status = Json.newObject();
    	String name = json.get("name").textValue();
    	String desc = json.get("desc").textValue();
    	Long from = json.get("from").longValue();
    	Long to = json.get("to").longValue();

    	//Create when no id is delivered
    	if(json.get("eventId")==null){
				event = Event.create(name, desc, from, to);
    			status.put(STATUS, "done");
    			status.put("eventId", event.getEventId());
    			return ok(status);
    	}
    	//Update when id is delivered
    	Long id = Long.parseLong(json.get("eventId").textValue());
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

    	if(events == null){
    		ObjectNode status = Json.newObject();
    		status.put(STATUS, "null");
    		return ok(status);
    	}
    	
    	if(limit!=0 && events!=null && events.size()>0){
    		return ok(Json.toJson(events.subList(0, limit)));
    	}
    	
    	return ok(Json.toJson(events));
    }

    public static Result getEvent(Long id) {
    	Event event = Event.find.byId(id);
    	if(event == null){
    		ObjectNode status = Json.newObject();
    		status.put(STATUS, "null");
    		return ok(status);
    	}
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

//#############REQUEST API################################    
    
    public static Result getRequests() {
    	List<Request> request = Request.find.all();

    	return ok(Json.toJson(request));
    }

    public static Result getRequest(Long id) {
    	Request request = null;
    	request = Request.find.byId(id);
    	if(request!=null){
    		return ok(Json.toJson(request));
    	}
    	
    	ObjectNode status = Json.newObject();
    	status.put(STATUS, "null");
    	return ok(status);
    	
    }

    @BodyParser.Of(BodyParser.Json.class)
    public static Result postRequest() {
    	Request request=null;
    	JsonNode json = request().body().asJson();
    	ObjectNode status = Json.newObject();
    	Long requestId = null;
    	Long replyTo = null;
    	if(json.has("requestId")){
    		requestId = Long.parseLong(json.get("requestId").textValue());
    	}
    	if(json.has("replyTo")){
    		replyTo = Long.parseLong(json.get("replyTo").textValue());
    	}
    	if(requestId!=null && replyTo==requestId){
    		status.put(STATUS, "no cycles");
    		return ok(status);
    	}
    	
    	String title = json.get("title").textValue();
    	String desc = json.get("desc").textValue();
    	Long user = Long.parseLong(json.get("user").textValue());
    	   
    	
    	//Create when no id is delivered
    	if(requestId==null){
    		 request = Request.create(title, desc, user, replyTo);
    		 status.put(STATUS, "done");
    		 status.put("id", request.getRequestId());
    		 return ok(status);
    	}
    	//Update when id is delivered
    	request = Request.find.byId(requestId);
    	if(request != null){
	    	request = request.update(title, desc, user, replyTo);
	    	status.put(STATUS, "updated");
	    	return ok(status);
    	}else{
    		status.put(STATUS, "null");
	    	return ok(status);
    	}
    }

    public static Result deleteRequest(Long id){
    	ObjectNode status = Json.newObject();
    	Request request = Request.find.byId(id);
    	if(request!=null){
        	request.deleteDependents();
    		request.delete();
    		status.put(STATUS, "deleted");
    	}
    	else{
        	status.put(STATUS, "null");
    	}
    	return ok(status);
    }
   
//#############Info API################################    
    
    public static Result getInfos() {
    	List<Info> info = Info.find.all();

    	return ok(Json.toJson(info));
    }

    public static Result getInfo(Long id) {
    	Info info = null;
    	info = Info.find.byId(id);
    	
    	if(info!=null){
    		return ok(Json.toJson(info));
    	}
    	
    	ObjectNode status = Json.newObject();
    	status.put(STATUS, "null");
    	return ok(status);
    }

    @BodyParser.Of(BodyParser.Json.class)
    public static Result postInfo() {
    	Info info=null;
    	JsonNode json = request().body().asJson();
    	ObjectNode status = Json.newObject();
    	Long infoId = null;
    	String content = null;
    	
    	if(json.has("infoId")){
    		infoId = Long.parseLong(json.get("infoId").textValue());
    	}

    	content = json.get("content").textValue();
 
    	
    	//Create when no id is delivered
    	if(infoId==null){
    		 info = Info.create(content);
    		 status.put(STATUS, "done");
    		 status.put("id", info.getInfoId());
    		 return ok(status);
    	}
    	//Update when id is delivered
    	info = Info.find.byId(infoId);
    	if(info != null){
    		info = info.updateInfo(content);
	    	status.put(STATUS, "updated");
	    	return ok(status);
    	}else{
    		status.put(STATUS, "null");
	    	return ok(status);
    	}
    }

    public static Result deleteInfo(Long id){
    	ObjectNode status = Json.newObject();
    	Info info = Info.find.byId(id);
    	if(info!=null){
    		info.delete();
    		status.put(STATUS, "deleted");
    	}
    	else{
        	status.put(STATUS, "null");
    	}
    	return ok(status);
    }

}
