package models;

import java.util.List;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;

import com.avaje.ebean.Expr;
import com.fasterxml.jackson.annotation.JsonProperty;

import play.db.ebean.Model;

@Entity
public class Event extends Model{
	
	@Id
	private Long eventId;
	private String name;
	@Column(name="description")
	private String desc;
	@JsonProperty("from")
	private Long fromEpoch;
	@JsonProperty("to")
	private Long toEpoch;

	public static Finder<Long, Event> find = new Finder<Long, Event>(Long.class, Event.class);
	
	public Event(String name, String desc, Long from, Long to) {
		this.name = name;
		this.desc = desc;
		this.fromEpoch = from;
		this.toEpoch = to ;
	}
	
	public static Event create(String name, String desc, Long from, Long to){
		Event event = new Event(name, desc, from, to);
		event.save();
		return event;
	}
	
	public static Event update(Long id, String name, String desc, Long from, Long to){
		Event event = Event.find.byId(id);
		event.setFromEpoch(from);
		event.setToEpoch(to);
		event.setName(name);
		event.setDesc(desc);
		event.save();
		return event;
	}

	public Long getEventId() {
		return eventId;
	}

	public void setEventId(Long eventId) {
		this.eventId = eventId;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public String getDesc() {
		return desc;
	}

	public void setDesc(String desc) {
		this.desc = desc;
	}
	
	public Long getFromEpoch() {
		return fromEpoch;
	}

	public void setFromEpoch(Long fromEpoch) {
		this.fromEpoch = fromEpoch;
	}

	public Long getToEpoch() {
		return toEpoch;
	}

	public void setToEpoch(Long toEpoch) {
		this.toEpoch = toEpoch;
	}

	public static List<Event> getEvents(Long from, Long to) throws NumberFormatException{	
		List<Event> events = find.where().or(Expr.between("fromEpoch", from, to),Expr.between("toEpoch", from, to)).findList();
		// get Events that startet before and ended after the requested date
		List<Event> events2 = find.where().and(Expr.lt("fromEpoch", from), Expr.gt("toEpoch",to)).findList();
		events.addAll(events2);		
		return events;
	}
	
	public static List<Event> getEvents(Long from) throws NumberFormatException{
		List<Event> events = find.where().gt("fromEpoch", from).findList();
		return events;
	}
	
	public static List<Event> getEvents(){
		List<Event> events = find.all();
		return events;
	}

}
