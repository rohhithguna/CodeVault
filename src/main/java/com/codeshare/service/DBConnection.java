package com.codeshare.service;

import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;

import com.zaxxer.hikari.HikariConfig;
import com.zaxxer.hikari.HikariDataSource;
import io.github.cdimascio.dotenv.Dotenv;

public class DBConnection {

	private static HikariDataSource dataSource;

	static {
		try {
			Dotenv dotenv = Dotenv.load();
			
			String dbUrl = dotenv.get("DATABASE_URL");
			String dbUsername = dotenv.get("DB_USERNAME");
			String dbPassword = dotenv.get("DB_PASSWORD");
			
			if (dbUrl == null || dbUsername == null || dbPassword == null) {
				System.err.println("Database configuration is missing. Set DATABASE_URL, DB_USERNAME and DB_PASSWORD.");
				throw new RuntimeException("Database configuration is missing.");
			}

			Class.forName("com.mysql.cj.jdbc.Driver");
			
			HikariConfig config = new HikariConfig();
			config.setJdbcUrl(dbUrl);
			config.setUsername(dbUsername);
			config.setPassword(dbPassword);
			config.setMaximumPoolSize(10);
			config.setMinimumIdle(2);
			config.setIdleTimeout(30000);
			config.setConnectionTimeout(10000);

			dataSource = new HikariDataSource(config);
		} catch (Exception e) {
			System.err.println("Db pool initialization error.");
			e.printStackTrace();
		}
	}

	private DBConnection() {
	}

	public static Connection getConnection() throws java.sql.SQLException {
		if (dataSource == null) {
			throw new java.sql.SQLException("DataSource is not initialized");
		}
		return dataSource.getConnection();
	}

}
