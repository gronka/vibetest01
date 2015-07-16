module test.routes;

mixin template RouteMethods() {

	class MixinNested {
		void howdy(HTTPServerRequest req, HTTPServerResponse res) 
		{
			writeMe = "I am a mixin";
			writeln(writeMe);
			res.writeBody("Howdy, I am a mixin!");
		}
	}
}
