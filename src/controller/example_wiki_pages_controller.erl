-module(example_wiki_pages_controller, [Req]).
-compile(export_all).

%% @doc show a "Hello World" message
index('GET', []) ->
	{output, "Hello World"}.
