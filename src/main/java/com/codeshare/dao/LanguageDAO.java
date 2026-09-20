package com.codeshare.dao;

import java.io.IOException;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.PreparedStatement;
import java.util.ArrayList;

import com.codeshare.model.Language;
import com.codeshare.service.DBConnection;

public class LanguageDAO {
	public LanguageDAO() {
	}

	public ArrayList<Language> getAllLanguages() {
		ArrayList<Language> list = new ArrayList<Language>();

		String $sql = "select * from Languages order by Name";
		try (Connection conn = DBConnection.getConnection();
			 PreparedStatement stmt = conn.prepareStatement($sql);
			 ResultSet rs = stmt.executeQuery()) {

			while (rs.next()) {
				list.add(new Language(rs.getInt("Id"), rs.getString("Name")));
			}
		} catch (SQLException e) {
			System.err.println("Database Error at getAllLanguages");
			e.printStackTrace();
		}
		return list;

	}
}
