package com.codeshare.dao;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import com.codeshare.service.DBConnection;

public class SharedWithDAO {
	public SharedWithDAO() {
	}

	public void addSharedWith(int source_id, int shared_user_id) {

		String sql = "insert into Shared_With(Source_Id, Shared_User_Id) VALUES(?, ?)";
		
		try (Connection conn = DBConnection.getConnection();
			 PreparedStatement stmt = conn.prepareStatement(sql)) {
			stmt.setInt(1, source_id);
			stmt.setInt(2, shared_user_id);
			stmt.executeUpdate();
		} catch (SQLException e) {
			 System.err.println("Database Error at addSharedWith");
			 e.printStackTrace();
		}
	}
}