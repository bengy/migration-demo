package models;

import javax.persistence.Entity;
import javax.persistence.Id;

import play.data.validation.Constraints;
import play.db.ebean.Model;

@Entity
public class ModellUser extends Model{
	@Id
	private long userId;
	@Constraints.Required
	private String name;
	private String lang;
	
	public long getUserId() {
		return userId;
	}

	public void setUserId(long userId) {
		this.userId = userId;
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

	public static Finder<Long, ModellUser> getFind() {
		return find;
	}

	public static void setFind(Finder<Long, ModellUser> find) {
		ModellUser.find = find;
	}

	public static Finder<Long, ModellUser> find = new Finder<Long, ModellUser>(Long.class, ModellUser.class);
}
