package models;

import javax.persistence.Id;

import play.db.ebean.Model;

public class Event extends Model{
	@Id
	private Long eventId;
	private String name;
	private String desc;
	private String from;
	private String to;
	
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

	public String getFrom() {
		return from;
	}

	public void setFrom(String from) {
		this.from = from;
	}

	public String getTo() {
		return to;
	}

	public void setTo(String to) {
		this.to = to;
	}

	public static Finder<Long, Event> getFind() {
		return find;
	}

	public static void setFind(Finder<Long, Event> find) {
		Event.find = find;
	}

	public static Finder<Long, Event> find = new Finder<Long, Event>(Long.class, Event.class);

}
