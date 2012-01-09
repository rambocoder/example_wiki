-module(page, [Id, PageTitle, PageText]).
-compile(export_all).

validation_tests() ->
	[{fun() -> length(PageTitle) > 0 end, "Page Title cannot be empty."},
	 {fun() -> length(PageTitle) =< 32 end, "Page Text cannot be more than 32 characters long."}].

