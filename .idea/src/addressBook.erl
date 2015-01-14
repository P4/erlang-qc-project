%%%-------------------------------------------------------------------
%%% @author Kubix
%%% @copyright (C) 2014, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 27. lis 2014 11:42
%%%-------------------------------------------------------------------
-module(addressBook).
-author("Kubix").

%% API
-export([createAddressBook/0, addContact/3,is_In/5, is_In/4,is_In_T/3,addEmail/4,addPhone/4,is_In_Phone/5,
  removeContact/3,removeEmail/2,removeEmail/3,removePhone/2,removePhone/3,getEmails/3,getPhones/3,findByEmail/2,
  findByPhone/2,sort_By_Field/2,less_FirstName/2,bigger_FirstName/2,less_LastName/2,bigger_LastName/2]).
-record(contact, {firstname, lastname, phone_number = [], mail = []}).

createAddressBook() -> [].

addContact([], FirstName, LastName) -> [#contact{firstname = FirstName, lastname = LastName}];
addContact([H | T], FirstName, LastName) -> case is_In([H|T],FirstName,LastName,1) of
                                            false  -> [#contact{firstname = FirstName, lastname = LastName},H | T];
                                            {true,_} -> "Such contact already exists"
                                            end.

is_In([], _, _,_) -> false;
is_In([#contact{firstname = FirstName, lastname = LastName} | _], FirstName, LastName,Count) -> {true,Count};
is_In([_|T], FirstName, LastName,Count) -> is_In(T,FirstName,LastName,Count+1).

is_In([], _, _,_,_) -> false;
is_In([#contact{firstname = FirstName, lastname = LastName} | T], FirstName, LastName, Mail,Count) -> case is_In_T(#contact.mail, Mail,1) of
                                                                                                  {true,_} -> true;
                                                                                                  false -> is_In(T,FirstName,LastName,Mail,Count+1)
                                                                                                end;
is_In([_|T], FirstName, LastName, Mail,Count) -> is_In(T,FirstName,LastName,Mail,Count+1).

is_In_T([],_,_) -> false;
is_In_T([Thing|_], Thing,Counter) -> {true,Counter};
is_In_T([_|T], Thing,Counter) -> is_In_T(T,Thing,Counter+1).


is_In_Phone([], _, _,_,_) -> false;
is_In_Phone([#contact{firstname = FirstName, lastname = LastName} | T], FirstName, LastName, Phone,Count) -> case is_In_T(#contact.phone_number,Phone,1) of
                                                                                                        {true,_} -> true;
                                                                                                        false -> is_In(T,FirstName,LastName,Phone,Count+1)
                                                                                                      end;
is_In_Phone([_|T], FirstName, LastName, Phone,Count) -> is_In(T,FirstName,LastName,Phone,Count+1).


addEmail([],FirstName,LastName,Mail) -> [#contact{firstname = FirstName, lastname = LastName, mail = [Mail]}];
addEmail([H|T],FirstName,LastName,Mail) -> case is_In([H|T],FirstName,LastName,1) of
                                              false -> [#contact{firstname = FirstName, lastname = LastName, mail = [Mail]},H|T];
                                             {true,Counter} ->   Contact = lists:nth(Counter,[H|T]),
                                                                 case is_In_T(Contact#contact.mail,Mail,1) of
                                                                 false -> lists:sublist([H|T],Counter-1) ++ [#contact{firstname = Contact#contact.firstname, lastname = Contact#contact.lastname,phone_number =  Contact#contact.phone_number,mail = [Mail | Contact#contact.mail]}] ++ lists:nthtail(Counter,[H|T]);
                                                                 {true,_} -> [H|T]
                                                               end
                                            end.

addPhone([],FirstName,LastName,Phone) -> [#contact{firstname = FirstName, lastname = LastName, phone_number = [Phone]}];
addPhone([H|T],FirstName,LastName,Phone) -> case is_In([H|T],FirstName,LastName,1) of
                                             false -> [#contact{firstname = FirstName, lastname = LastName, phone_number = [Phone]},H|T];
                                             {true,Counter} ->   Contact = lists:nth(Counter,[H|T]),
                                                                 case is_In_T(Contact#contact.phone_number,Phone,1) of
                                                                 false -> lists:sublist([H|T],Counter-1) ++ [#contact{firstname = Contact#contact.firstname, lastname = Contact#contact.lastname,phone_number = [Phone | Contact#contact.phone_number],mail = Contact#contact.mail}] ++ lists:nthtail(Counter,[H|T]);
                                                                 {true,_} -> [H|T]
                                                               end
                                           end.

removeContact([H|T],FirstName, LastName) -> case is_In([H|T],FirstName, LastName,0) of
                                              false -> [H|T];
                                              {true,Counter} -> lists:sublist([H|T],Counter-1) ++ lists:nthtail(Counter,[H|T])
                                            end.

removeEmail([H|T],Mail) -> removeEmail([H|T],Mail,[H|T]).
removeEmail([],_,[H|T]) -> [H|T];
removeEmail([H|T],Mail,[H|T]) -> case is_In_T(H#contact.mail,Mail,1) of
                             {true,Counter} -> Contact = lists:nth(Counter,[H|T]), lists:sublist([H|T],Counter-1) ++ [#contact{firstname = Contact#contact.firstname, lastname = Contact#contact.lastname, phone_number =  Contact#contact.phone_number,mail = lists:subtract(H#contact.mail,[Mail])}] ++ lists:nthtail(Counter,[H|T]);
                             false -> removeEmail(T,Mail,T)
                           end.

removePhone([H|T],Phone) -> removePhone([H|T],Phone,[H|T]).
removePhone([],_,[H|T]) -> [H|T];
removePhone([H|T],Phone,[H|T]) -> case is_In_T(H#contact.phone_number,Phone,1) of
                                   {true,Counter} -> Contact = lists:nth(Counter,[H|T]), lists:sublist([H|T],Counter-1) ++ [#contact{firstname = Contact#contact.firstname, lastname = Contact#contact.lastname,phone_number = lists:subtract(H#contact.phone_number,[Phone]) ,mail = Contact#contact.mail}] ++ lists:nthtail(Counter,[H|T]);
                                   false -> removePhone(T,Phone,T)
                                 end.

getEmails([H|T],FirstName,LastName) -> case is_In([H|T],FirstName,LastName,1) of
                                         false -> [];
                                         {true,Counter} -> Contact = lists:nth(Counter,[H|T]), Contact#contact.mail
                                       end.

getPhones([H|T],FirstName,LastName) -> case is_In([H|T],FirstName,LastName,1) of
                                         false -> [];
                                         {true,Counter} -> Contact = lists:nth(Counter,[H|T]), Contact#contact.phone_number
                                       end.

findByEmail([],_) -> "No Such Person";
findByEmail([H|T],Mail) -> case is_In_T(H#contact.mail,Mail,1) of
                             {true,_} -> H#contact.firstname ++ " " ++ H#contact.lastname;
                             false -> findByEmail(T,Mail)
                           end.

findByPhone([],_) -> "No Such Person";
findByPhone([H|T],Phone) -> case is_In_T(H#contact.phone_number,Phone,1) of
                             {true,_} -> H#contact.firstname ++ " " ++ H#contact.lastname;
                             false -> findByPhone(T,Phone)
                           end.

less_FirstName(R,FirstName) -> [X || X <- R, X#contact.firstname<FirstName#contact.firstname].

bigger_FirstName(R,FirstName) -> [X || X <- R, X#contact.firstname>=FirstName#contact.firstname].

less_LastName(R,LastName) -> [X || X <- R, X#contact.lastname<LastName#contact.lastname].

bigger_LastName(R,LastName) -> [X || X <- R, X#contact.lastname>=LastName#contact.lastname].

sort_By_Field([],_) -> [];
sort_By_Field([Pivot|Tail],firstname) -> sort_By_Field( less_FirstName(Tail,Pivot),firstname ) ++ [Pivot] ++ sort_By_Field( bigger_FirstName(Tail,Pivot), firstname);
sort_By_Field([Pivot|Tail],lastname) -> sort_By_Field( less_LastName(Tail,Pivot),lastname ) ++ [Pivot] ++ sort_By_Field( bigger_LastName(Tail,Pivot), lastname);
sort_By_Field(_,_) -> "No Such Field".

