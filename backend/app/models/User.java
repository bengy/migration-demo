package models;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.Table;

import play.data.validation.Constraints;
import play.db.ebean.Model;

@Entity
@Table(name="Client")
public class User extends Model{
	@Id
	private long clientId;
	@Constraints.Required
	@Column(unique=true)
	private String name;
	private String lang;
	
	public User(String name, String lang) {
		super();
		this.name = name;
		this.lang = lang;
	}
	
	public static User create(String name, String lang){
		User user = new User(name, lang);
		user.save();
		return user;
	}
	
	public static User update(String id, String lang){
		//Names cannot change
		User user = User.find.byId(Long.parseLong(id));
		user.setLang(lang);
		user.save();
		return user;
	}
	
	

	public long getUserId() {
		return clientId;
	}

	public void setUserId(long userId) {
		this.clientId = userId;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public String getLang() {
		return lang;
	}

	public void setLang(String lang) {
		this.lang = lang;
	}
	
	public static Finder<Long, User> find = new Finder<Long, User>(Long.class, User.class);	
}
