package com.codeshare.dao;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Types;
import java.util.ArrayList;
import java.util.Arrays;

import com.codeshare.model.SourceCode;
import com.codeshare.service.DBConnection;

public class SourceCodeDAO {
	public SourceCodeDAO() {
	}

	public int addSourceCode(String title, int language, int visibility, String source, int created_by,
			String created_by_alt, String created_at, String expire_at, int status, String[] share_with) {
		String sql = "insert into Source_Codes(Title, LanguageId, Visibility, Code, CreatedBy, CreatedByAlt, CreatedAt, ExpireAt, Status) VALUES(?, ?, ?, ?, ?, ?, ?, ?, ?)";
		try (Connection conn = DBConnection.getConnection();
			 PreparedStatement stmt = conn.prepareStatement(sql, PreparedStatement.RETURN_GENERATED_KEYS)) {
			stmt.setString(1, title);
			stmt.setInt(2, language);
			stmt.setInt(3, visibility);
			stmt.setString(4, source);
			stmt.setInt(5, created_by);
			stmt.setString(6, created_by_alt);
			stmt.setString(7, created_at);
			if (expire_at != null) {
				stmt.setString(8, expire_at);
			} else {
				stmt.setNull(8, Types.NULL);
			}
			stmt.setInt(9, status);
			int res = stmt.executeUpdate();
			System.out.println("res: " + res);
			
			int last_inserted_id = -1;
			try (ResultSet generatedKeys = stmt.getGeneratedKeys()) {
				if (generatedKeys.next()) {
					last_inserted_id = generatedKeys.getInt(1);
				}
			}

			if (visibility == 3 && last_inserted_id != -1 && share_with != null) {
				SharedWithDAO shared_with_dao = new SharedWithDAO();
				for (String user_id : share_with) {
					shared_with_dao.addSharedWith(last_inserted_id, Integer.parseInt(user_id));
				}
			}
			System.out.println("inserted...");
			return last_inserted_id;
		} catch (SQLException e) {
			System.err.println("Database Error at addSourceCode");
			e.printStackTrace();
			return -1;
		}
	}

	public int getVisibilityByID(int id) {
		int visibility = 0;
		String sql = "SELECT Visibility FROM Source_Codes WHERE Id = ?";
		try (Connection conn = DBConnection.getConnection();
			 PreparedStatement stmt = conn.prepareStatement(sql)) {
			stmt.setInt(1, id);
			try (ResultSet rs = stmt.executeQuery()) {
				if (rs.next()) {
					visibility = rs.getInt("Visibility");
				}
			}
		} catch (SQLException e) {
			System.err.println("Database Error at getVisibilityByID");
			e.printStackTrace();
		}
		return visibility;
	}

	public SourceCode getDetailsByID(int id) {
		SourceCode details = null;
		String sql = "SELECT Source_Codes.*, Users.Name AS CreatedByName, Languages.Name AS Language, GROUP_CONCAT(Shared_With.Shared_User_Id) AS Shared_Persons FROM Source_Codes JOIN Languages ON Source_Codes.LanguageId = Languages.Id LEFT JOIN Users ON Source_Codes.CreatedBy = Users.Id LEFT JOIN Shared_With ON Source_Codes.Id = Shared_With.Source_Id WHERE Source_Codes.Id = ? AND Source_Codes.Status = 1 GROUP BY Source_Codes.Id";
		try (Connection conn = DBConnection.getConnection();
			 PreparedStatement stmt = conn.prepareStatement(sql)) {
			stmt.setInt(1, id);

			try (ResultSet rs = stmt.executeQuery()) {
				if (rs.next()) {
					details = new SourceCode(rs.getInt("Id"), rs.getString("Title"), rs.getString("Language"),
							rs.getString("Code"), rs.getInt("Visibility"), rs.getInt("createdBy"),
							rs.getObject("createdByName") != null ? rs.getString("createdByName") : "",
							rs.getObject("createdByAlt") != null ? rs.getString("createdByAlt") : "",
							rs.getObject("Shared_Persons") != null ? Arrays.stream(rs.getString("Shared_Persons").split(","))
									.mapToInt(Integer::parseInt).toArray() : new int[] {},
							rs.getString("CreatedAt"), rs.getString("ExpireAt"), rs.getInt("Status"));
				}
			}

		} catch (SQLException e) {
			System.err.println("Database Error at getDetailsByID");
			e.printStackTrace();
		}
		return details;
	}

	public ArrayList<SourceCode> getLibraryByUser(int user_id) {
		ArrayList<SourceCode> library = new ArrayList<SourceCode>();
		String sql = "SELECT Source_Codes.*, Users.Name AS CreatedByName, Languages.Name AS Language, GROUP_CONCAT(Shared_With.Shared_User_Id) AS Shared_Persons FROM Source_Codes JOIN Languages ON Source_Codes.LanguageId = Languages.Id LEFT JOIN Users ON Source_Codes.CreatedBy = Users.Id LEFT JOIN Shared_With ON Source_Codes.Id = Shared_With.Source_Id WHERE Source_Codes.CreatedBy = ? AND Source_Codes.Status != 3 GROUP BY Source_Codes.Id";
		try (Connection conn = DBConnection.getConnection();
			 PreparedStatement stmt = conn.prepareStatement(sql)) {
			stmt.setInt(1, user_id);
			try (ResultSet rs = stmt.executeQuery()) {
				while (rs.next()) {
					library.add(new SourceCode(rs.getInt("Id"), rs.getString("Title"), rs.getString("Language"),
							rs.getString("Code"), rs.getInt("Visibility"), rs.getInt("createdBy"),
							rs.getObject("createdByName") != null ? rs.getString("createdByName") : "",
							rs.getObject("createdByAlt") != null ? rs.getString("createdByAlt") : "",
							rs.getObject("Shared_Persons") != null ? Arrays
									.stream(rs.getString("Shared_Persons").split(",")).mapToInt(Integer::parseInt).toArray()
									: new int[] {},
							rs.getString("CreatedAt"), rs.getString("ExpireAt"), rs.getInt("Status")));
				}
			}
		} catch (SQLException e) {
			System.err.println("Database Error at getLibraryByUser");
			e.printStackTrace();
		}
		return library;
	}

	public ArrayList<SourceCode> getSharedSourceByUser(int user_id) {
		ArrayList<SourceCode> source_list = new ArrayList<SourceCode>();
		String sql = "SELECT Source_Codes.*, Languages.Name AS Language, Users.Name AS CreatedByName FROM Shared_With JOIN Source_Codes ON Shared_With.Source_Id = Source_Codes.Id JOIN Users ON Source_Codes.CreatedBy = Users.Id JOIN Languages ON Source_Codes.LanguageId = Languages.Id WHERE Shared_With.Shared_User_Id = ? AND Source_Codes.Status = 1";
		try (Connection conn = DBConnection.getConnection();
			 PreparedStatement stmt = conn.prepareStatement(sql)) {
			stmt.setInt(1, user_id);
			try (ResultSet rs = stmt.executeQuery()) {
				while (rs.next()) {
					source_list.add(new SourceCode(rs.getInt("Id"), rs.getString("Title"), rs.getString("Language"),
							rs.getString("Code"), rs.getInt("Visibility"), rs.getInt("createdBy"),
							rs.getObject("createdByName") != null ? rs.getString("createdByName") : "",
							rs.getObject("createdByAlt") != null ? rs.getString("createdByAlt") : "", new int[] {},
							rs.getString("CreatedAt"), rs.getString("ExpireAt"), rs.getInt("Status")));
				}
			}
		} catch (SQLException e) {
			System.err.println("Database Error at getSharedSourceByUser");
			e.printStackTrace();
		}

		return source_list;
	}

	public void changeStatus(int id) {
		String sql = "update Source_Codes set Status= case when Status=1 then 2 else 1 END where Source_Codes.Id = ?";
		try (Connection conn = DBConnection.getConnection();
			 PreparedStatement stmt = conn.prepareStatement(sql)) {
			stmt.setInt(1, id);
			stmt.executeUpdate();
		} catch (SQLException e) {
			System.err.println("Database Error at changeStatus");
			e.printStackTrace();
		}
	}
}
