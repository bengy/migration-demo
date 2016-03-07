package models;

import javax.persistence.Entity;
import javax.persistence.Id;

import play.data.validation.Constraints;
import play.db.ebean.Model;

@Entity
public class Client extends Model{
	@Id
	private long clientId;
	@Constraints.Required
	private String name;
	private String lang;
	
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

	public static Finder<Long, Client> getFind() {
		return find;
	}

	public static void setFind(Finder<Long, Client> find) {
		Client.find = find;
	}

	public static Finder<Long, Client> find = new Finder<Long, Client>(Long.class, Client.class);
}
