package models;

import java.util.Date;
import java.util.List;

import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.OneToOne;

import com.fasterxml.jackson.annotation.JsonProperty;

import play.db.ebean.Model;

@Entity
public class Request extends Model{

	@Id
	private Long requestId;
	private String title;
	@JsonProperty("desc")
	private String info;
	private Long inserted;
	@OneToOne
	private User user;
	@OneToOne
	private Request replyTo;
	
	public static Finder<Long, Request> find = new Finder<Long, Request>(Long.class, Request.class);

	
	public Request(String title, String desc, Long inserted, User user, Request replyTo) {
		super();
		this.title = title;
		this.info = desc;
		this.inserted = inserted;
		this.user = user;
		this.replyTo = replyTo;
	}
	
	public static Request create(String title, String desc, Long user, Long replyTo) {
		Long inserted = new Date().getTime();
		Request request;
		if(replyTo!=null){
			 request = new Request(title, desc, inserted, User.find.byId(user), Request.find.byId(replyTo));
		}
		else{
			 request = new Request(title, desc, inserted, User.find.byId(user), null);
		}
		request.save();
		return request;
	}
	
	public Request update(String title, String desc, Long user, Long replyTo){
		this.setTitle(title);
		this.setDesc(desc);
		this.setUser(User.find.byId(user));
		if(replyTo!=null){
			this.setReplyTo(Request.find.byId(replyTo));
		}		
		this.save();
		return this;
	}
	
	public void deleteDependents(){
		List<Request> dependents = Request.find.where().eq("replyTo.requestId", this.requestId).findList();
		for(Request d : dependents){
			d.delete();
		}
		return;
	}
	
	
	public Long getRequestId() {
		return requestId;
	}
	public void setRequestId(Long requestId) {
		this.requestId = requestId;
	}
	public String getTitle() {
		return title;
	}
	public void setTitle(String title) {
		this.title = title;
	}
	public String getDesc() {
		return info;
	}
	public void setDesc(String desc) {
		this.info = desc;
	}
	public Long getInserted() {
		return inserted;
	}
	public void setInserted(Long inserted) {
		this.inserted = inserted;
	}
	public User getUser() {
		return user;
	}
	public void setUser(User user) {
		this.user = user;
	}
	public Request getReplyTo() {
		return replyTo;
	}
	public void setReplyTo(Request replyTo) {
		this.replyTo = replyTo;
	}
	
	
}
