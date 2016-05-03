ExUnit.start

Mix.Task.run "ecto.create", ~w(-r Phxblog.Repo --quiet)
Mix.Task.run "ecto.migrate", ~w(-r Phxblog.Repo --quiet)
Ecto.Adapters.SQL.begin_test_transaction(Phxblog.Repo)

