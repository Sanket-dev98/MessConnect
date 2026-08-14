import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.Statement;
import java.util.Properties;

/**
 * Standalone Supabase connectivity check.
 *
 * The connection string is read from the SUPABASE_DB_URL env var *inside* Java,
 * so the secret is never passed on the command line. Connects, reports the
 * Postgres version, lists this project's tables, and confirms the Flyway
 * migration (V1) is present when already applied.
 */
public class DbCheck {
	public static void main(String[] args) throws Exception {
		String url = System.getenv("SUPABASE_DB_URL");
		if (url == null || url.isBlank()) {
			System.out.println("RESULT=FAIL reason=SUPABASE_DB_URL not set");
			System.exit(2);
		}

		Properties props = new Properties();
		props.setProperty("ssl", "true");
		props.setProperty("sslmode", "require");

		try (Connection conn = DriverManager.getConnection(url, props)) {
			System.out.println("RESULT=OK");

			try (Statement st = conn.createStatement();
				 ResultSet rs = st.executeQuery("select version()")) {
				if (rs.next()) {
					System.out.println("VERSION=" + rs.getString(1));
				}
			}

			try (Statement st = conn.createStatement();
				 ResultSet rs = st.executeQuery(
						 "select count(*) from information_schema.tables "
						 + "where table_schema='public'")) {
				if (rs.next()) {
					System.out.println("PUBLIC_TABLES=" + rs.getInt(1));
				}
			}

			try (Statement st = conn.createStatement();
				 ResultSet rs = st.executeQuery(
						 "select to_regclass('public.users') is not null as has_users, "
						 + "to_regclass('public.messes') is not null as has_messes, "
						 + "to_regclass('public.reviews') is not null as has_reviews")) {
				if (rs.next()) {
					System.out.println("SCHEMA_USERS=" + rs.getBoolean("has_users")
							+ " MESSES=" + rs.getBoolean("has_messes")
							+ " REVIEWS=" + rs.getBoolean("has_reviews"));
				}
			}
		} catch (Exception e) {
			System.out.println("RESULT=FAIL reason=" + e.getClass().getSimpleName()
					+ " msg=" + e.getMessage());
			System.exit(1);
		}
	}
}
