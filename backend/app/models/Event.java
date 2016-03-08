package models;

import java.util.Collection;
import java.util.List;

import javax.persistence.Id;

import org.joda.time.DateTime;

import play.db.ebean.Model;

public class Event extends Model{
	@Id
	private Long eventId;
	private String name;
	private String desc;
	private DateTime from;
	private DateTime to;

	public static Finder<Long, Event> find = new Finder<Long, Event>(Long.class, Event.class);
	
	public Event(String name, String desc, DateTime from, DateTime to) {
		this.name = name;
		this.desc = desc;
		this.setFrom(from);
		this.setTo(to);
	}
	
	public Event create(String name, String desc, DateTime from, DateTime to){
		Event event = new Event(name, desc, from, to);
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

	

	public DateTime getTo() {
		return to;
	}

	public void setTo(DateTime to) {
		this.to = to;
	}



	public DateTime getFrom() {
		return from;
	}

	public void setFrom(DateTime from) {
		this.from = from;
	}

	public static List<Event> getEvents(String from, String to){
		DateTime dtFrom = DateTime.parse(from);
		DateTime dtTo = DateTime.parse(to);
		List<Event> events = find.where().between("from", dtFrom, dtTo).findList();
		events.addAll(find.where().between("to", dtFrom, dtTo).findList());
		return events;
	}
	public static List<Event> getEvents(String from){
		DateTime dtFrom = DateTime.parse(from);
		List<Event> events = find.where().gt("from", dtFrom).findList();
		return events;
	}
}
