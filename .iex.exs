# Global variables available from REPL
alias SecretFriends.API.SFList

sflist = SFList.new()

sflist
|> SFList.add_friend("Pepe")
|> SFList.add_friend("Juana")
|> SFList.add_friend("Martino")
|> SFList.create_selection()

IO.puts("Now your have your friends loaded in context")
