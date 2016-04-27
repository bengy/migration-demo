package models;

import java.util.Date;

import javax.persistence.Entity;
import javax.persistence.Id;

import play.db.ebean.Model;

@Entity
public class Info extends Model{

	@Id
	private Long infoId;
	private String content;
	private Long timestamp;
	
	public static Finder<Long, Info> find = new Finder<Long, Info>(Long.class, Info.class);

	public Info(String content) {
		super();
		this.content = content;
	}
	
	public static Info create(String content){
		Info info = new Info(content);
		info.save();
		info.timestamp = new Date().getTime();
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
		return timestamp;
	}
	public void setTime(Long timestamp) {
		this.timestamp = timestamp;
	}
	

	
	
}
