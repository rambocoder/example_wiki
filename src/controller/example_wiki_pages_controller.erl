-module(example_wiki_pages_controller, [Req]).
-compile(export_all).
-default_action(index).

service('WS', []) ->
	%io:format("WAITING~n", []),
	Ws = Req,
	receive
		{browser, Data} ->
			io:format("RECEIVED ~p~n", [Data]),
			Ws:send(["received '", Data, "'"]),
			ok;
		_Ignore ->
			ok
	after 10000 ->
		Ws:send("pushing!"),
		ok
	end.

%% @doc show a list of all wiki pages out there
index('GET', []) ->
	Pages = boss_db:find(page, []),
	{ok, [{pages, Pages}]}.

%% @doc show a specific wiki page
view('GET', [Id]) ->
	case boss_db:find(Id) of
		{error, Reason} -> {redirect, [{action, "create"}]}; %% TODO: Redirect to error page
		undefined -> {redirect, [{action, "create"}]}; % When you visit /view/NotExistentPage the requested Page doesn't exist, we redirect the client to the edit Page so the content may be created
		ExistingWikiPage -> 
			% Replace all [page-id] with links
			% TODO: There has to be a better way, such as using Markdown
			% or custom filter for ErlyDTL https://groups.google.com/d/topic/erlydtl-users/ECzOKAxcsXo/discussion
			StartHrefs = re:replace(ExistingWikiPage:page_text(), "\\[\\w*\-*[0-9]*", "<a href='/pages/view/&'>&", [global, {return, list}]),
			ClosedHrefs = re:replace(StartHrefs, "\\]", "</a>", [global, {return, list}]),
			Cleaned2 = re:replace(ClosedHrefs, <<"\\[">>, "", [global, {return, list}]),
			{ok, [{page, ExistingWikiPage}, {cleaned, Cleaned2}]}
	end.

%% @doc Handles rendering the new wiki page view
create('GET', []) -> ok;

%% @doc Handles form submission	for new wiki page
create('POST', []) ->
	Title = Req:post_param("page_title"),
	Text = Req:post_param("page_text"),
	NewWikiPage = page:new(id, Title, Text),
	case NewWikiPage:save() of
		{ok, SavedWikiPage} -> 	{redirect, [{action, "view"}, {id, SavedWikiPage:id()}]}; 
		{error, ErrorList} -> {ok, [{errors, ErrorList}, {new_page, NewWikiPage}]}
	end.
	
%% @doc Fetch the existing wiki and show the edit page
edit('GET', [Id]) ->
	ExistingWikiPage = boss_db:find(Id),
	{ok, [{page, ExistingWikiPage}]};

%% @doc Updates the wiki page from the Edit view POST information	
edit('POST', []) ->
	Id = Req:post_param("page_id"),
	Title = Req:post_param("page_title"),
	Text = Req:post_param("page_text"),
	ExistingWikiPage = boss_db:find(Id),
	UpdatedWikiPage = ExistingWikiPage:set( [{page_text, Text}, {page_title, Title}] ),	
	case UpdatedWikiPage:save() of
		{ok, SavedWiki} -> 	{redirect, [{action, "view"}, {id, Id}]}; % Redirect to the updated page
		{error, ErrorList} -> {ok, [{errors, ErrorList}, {page, UpdatedWikiPage}]}
	end.

%% @doc upload of images to the wiki
%% Req is simple_bridge request object, API at https://github.com/nitrogen/simple_bridge
%% @end
upload('GET', []) -> ok;	
upload('POST', []) -> 
	error_logger:info_msg("Uploaded file info: ~p~n", [Req:post_files()]),
	ok.
