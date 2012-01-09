-module(pages_helper).
-compile(export_all).

%% @Doc fast binary string replacement, taken from http://www.trapexit.org/forum/viewtopic.php?p=44337
bin_replace2(What, From, To) -> 
    bin_replace2(What, erlang:byte_size(From), What, From, To, 0). 

bin_replace2(WhatOrig, FromLen, What, From, To, Cnt) -> 
    case What of 
        <<From:FromLen/binary, Right/binary>> -> 
            OtherRepl = bin_replace2(Right, From, To), 
            <<Left:Cnt/binary,_/binary>> = WhatOrig, 
            <<Left/binary, To/binary, OtherRepl/binary>>; 
        <<_:8, Other/binary>> -> 
            bin_replace2(WhatOrig, FromLen, Other, From, To, Cnt+1); 
 
        <<>> -> 
            WhatOrig 
    end. 

