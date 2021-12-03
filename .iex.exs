# Global variables available from REPL
alias SecretFriends.API.SFList

sflist = SFList.new(:friends)

sflist
|> SFList.add_friend("Pepe")
|> SFList.add_friend("Juana")
|> SFList.add_friend("Martino")
|> SFList.create_selection()

IO.puts("Now your have your friends loaded in context")

IO.puts(SFList.show(:friends))
