import vibe.d;

import std.stdio;

import cassandra.client;
import cassandra.cql.utils;
import cassandra.cql.result;
import cassandra.cql.connection;

import vibe.data.json;

shared static this()
{

	auto router = new URLRouter;

	auto settings = new HTTPServerSettings;
	settings.port = 9090;
	settings.bindAddresses = ["::1", "127.0.0.1"];
	settings.options |= HTTPServerOption.distribute;

	registerTest(router);
	listenHTTP(settings, router);

	logInfo("Please oprn http://127.0.0.1:9090/ in your browser.");
}


CassandraClient connectCassandraDB(string host, ushort port = Connection.defaultPort)
{
	return new CassandraClient(host, port);
}


void registerTest(URLRouter router) {
	auto myTest = new Test(router);
}
class Test {
	CassandraClient cassandra;
	CassandraKeyspace ks;
	
	this(URLRouter router) {
		cassandra = connectCassandraDB("127.0.0.1", 9042);
		try ks = cassandra.getKeyspace("users");
		catch (Exception e) ks = cassandra.createKeyspace("users");

		register(router);
	}
	void register(URLRouter router) {
		router.get("/", &index);
		router.post("/admin/json/dropUserCFs", &initUserTable);
		router.post("/admin/json/initUserCFs", &dropUserTable);
		router.get("*", serveStaticFiles("public"));
	}

	void index(HTTPServerRequest req, HTTPServerResponse res)
	{
		res.render!("index.dt", req);
	}
	void initUserTable(HTTPServerRequest req, HTTPServerResponse res)
	{
		try {
			log("CREATE TABLE ");
			auto resp = ks.query(`CREATE TABLE users (
					user_name varchar,
					password varchar,
					gender varchar,
					session_token varchar,
					state varchar,
					birth_year bigint,
					PRIMARY KEY (user_name)
					)`, Consistency.any);
			log("created table %s %s %s %s", resp.kind, resp.keyspace, resp.lastchange, resp.table);
		} catch (Exception e) { log(e.msg); }

		res.writeJsonBody("Success");
	}

	void dropUserTable(HTTPServerRequest req, HTTPServerResponse res)
	{
		try {
			ks.query(`drop table users;`);
		} catch (Exception e) { log(e.msg);  
		}
		res.writeJsonBody("Success");
	}


}

