package com.codeshare.dao;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;

import com.codeshare.model.User;
import com.codeshare.service.DBConnection;

public class UserDAO {
	public UserDAO() {
	}

	public User checkLogin(String username, String password) {
		User user = null;
		String sql = "select * from Users where Username = ?";
		try (Connection conn = DBConnection.getConnection();
			 PreparedStatement stmt = conn.prepareStatement(sql)) {
			stmt.setString(1, username);
			try (ResultSet rs = stmt.executeQuery()) {
				if (rs.next()) {
					String dbPassword = rs.getString("Password");
					boolean passwordMatch = false;

					if (dbPassword != null && dbPassword.startsWith("$2a$")) {
						passwordMatch = org.mindrot.jbcrypt.BCrypt.checkpw(password, dbPassword);
					} else {
						// Fallback for plaintext migration
						if (password.equals(dbPassword)) {
							passwordMatch = true;
							// Migrate to hashed password immediately
							String newHash = org.mindrot.jbcrypt.BCrypt.hashpw(password, org.mindrot.jbcrypt.BCrypt.gensalt());
							try (PreparedStatement updateStmt = conn.prepareStatement("UPDATE Users SET Password = ? WHERE Id = ?")) {
								updateStmt.setString(1, newHash);
								updateStmt.setInt(2, rs.getInt("Id"));
								updateStmt.executeUpdate();
							}
						}
					}

					if (passwordMatch) {
						user = new User(
								rs.getInt("Id"),
								rs.getString("Name"),
								rs.getString("Username"),
								rs.getString("Email"),
								rs.getString("CreatedAt"),
								rs.getString("UpdatedAt"),
								rs.getInt("Status"));
					}
				}
			}
		} catch (SQLException e) {
			System.err.println("Database Error at checkLogin");
			e.printStackTrace();
		}
		return user;
	}

	public ArrayList<User> getAllUsers(int user_id) {
		ArrayList<User> users = new ArrayList<User>();
		String sql = "select * from Users where Id != ?";
		try (Connection conn = DBConnection.getConnection();
			 PreparedStatement stmt = conn.prepareStatement(sql)) {
			stmt.setInt(1, user_id);
			try (ResultSet rs = stmt.executeQuery()) {
				while (rs.next()) {
					users.add(
							new User(rs.getInt("Id"), rs.getString("Name"), rs.getString("Username"), rs.getString("Email"),
									rs.getString("CreatedAt"), rs.getString("UpdatedAt"), rs.getInt("Status")));
				}
			}
		} catch (SQLException e) {
			System.err.println("Database Error at getAllUsers");
			e.printStackTrace();
		}

		return users;
	}

	public boolean checkUserExists(String username, String email) {
		boolean exists = false;
		String sql = "SELECT * FROM Users WHERE Username = ? OR Email = ?";
		try (Connection conn = DBConnection.getConnection();
			 PreparedStatement stmt = conn.prepareStatement(sql)) {
			stmt.setString(1, username);
			stmt.setString(2, email);
			try (ResultSet rs = stmt.executeQuery()) {
				if (rs.next()) {
					exists = true;
				}
			}
		} catch (SQLException e) {
			System.err.println("Database Error at checkUserExists");
			e.printStackTrace();
		}
		return exists;
	}

	public boolean insertUser(String name, String username, String email, String password, String createdAt) {
		String sql = "INSERT INTO Users (Name, Username, Email, Password, CreatedAt, Status) VALUES (?, ?, ?, ?, ?, 1)";
		try (Connection conn = DBConnection.getConnection();
			 PreparedStatement stmt = conn.prepareStatement(sql)) {
			String hashedPassword = org.mindrot.jbcrypt.BCrypt.hashpw(password, org.mindrot.jbcrypt.BCrypt.gensalt());
			stmt.setString(1, name);
			stmt.setString(2, username);
			stmt.setString(3, email);
			stmt.setString(4, hashedPassword);
			stmt.setString(5, createdAt);
			int rows = stmt.executeUpdate();
			return rows > 0;
		} catch (SQLException e) {
			System.err.println("Database Error at insertUser");
			e.printStackTrace();
			return false;
		}
	}
}
