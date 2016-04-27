package models;

import javax.persistence.Entity;

import play.db.ebean.Model;

@Entity
public class Info extends Model{

	private Long infoId;
	private String content;
	private Long time;
	
	public static Finder<Long, Info> find = new Finder<Long, Info>(Long.class, Info.class);

	public Info(String content) {
		super();
		this.content = content;
	}
	
	public static Info create(String content){
		Info info = new Info(content);
		info.save();
		return info;
	}
	
	public Info updateInfo(String content){
		this.content=content;
		return this;
	}
		
		
	public Long getInfoId() {
		return infoId;
	}
	public void setInfoId(Long infoId) {
		this.infoId = infoId;
	}
	public String getContent() {
		return content;
	}
	public void setContent(String content) {
		this.content = content;
	}
	public Long getTime() {
		return time;
	}
	public void setTime(Long time) {
		this.time = time;
	}
	

	
	
}
