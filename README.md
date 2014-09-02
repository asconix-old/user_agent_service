# User Agent Service

This microservice delivers random HTTP User-Agent strings considering filter parameters e.g. for crawler agents, desktop browsers, mobile clients etc.

# Installation on Heroku

Heroku provides a way to run an Elixir & Phoenix application by using a 3rd party Heroku buildpack. The deployment is pretty painless when you follow the instructions described in this tutorial.

Note: I'm using [HashNuke's Heroku buildpack for Elixir](https://github.com/HashNuke/heroku-buildpack-elixir). Due to the fact that Elixir 1.0.0-rc2 has been released 2 days ago (31st August 2014) and this buildpack doesn't support it officially yet, I created a fork of it that provides the prebuilt Elixir branch (master branch). You find the forked repository at [https://github.com/asconix/heroku-buildpack-elixir](https://github.com/asconix/heroku-buildpack-elixir). I suppose that the original buildpack will support the current Elixir version within the next few days so that you can switch back to HashNuke's buildpack.

# Phoenix web application

Due to the fact that this is a tutorial about deploying a web application on Heroku such a web application is needed. For this tutorial I use exemplary the User Agent Service which provides a JSON API and is built on top of Elixir & Phoenix ([www.github.com/asconix/user_agent_service](http://www.github.com/asconix/user_agent_service)). The web application is PostgreSQL backed. A separate chapter describes how to set up the database, fill it with initial data etc. 

First of all clone the public Git repository of the User Agent Service web application:

    $~ cd ~/projects
    $~ git clone git@github.com:asconix/user_agent_service.git

# Creation of a Heroku app

For a project that will be hosted on Heroku you need to create an appropriate Heroku application. To create a new Heroku app `user-agent-service` launch the following command within the application directory:

    $~ cd ~/projects/user_agent_service
    $~ heroku apps:create user-agent-service --buildpack "https://github.com/asconix/heroku-buildpack-elixir"

You should get a feedback message similar to:

    Creating user-agent-service... done, stack is cedar
    BUILDPACK_URL=https://github.com/asconix/heroku-buildpack-elixir
    http://user-agent-service.herokuapp.com/ | git@heroku.com:user-agent-service.git

Note: if you have already created a Heroku app for a project and just want to set a new buildpack for it, launch the following command:

    $~ cd ~/projects/user_agent_service
    $~ heroku config:set BUILDPACK_URL="https://github.com/asconix/heroku-buildpack-elixir.git"

In that case the output looks like:

    Setting config vars and restarting user-agent-service... done, v4
    BUILDPACK_URL: https://github.com/asconix/heroku-buildpack-elixir.git

The commands above create additionally the appropriate Git remote. A Git remote is basically a reference to a remote repository that is required to deploy the application to Heroku. Check if the new Git remote has been added properly:

    $~ git remote -v

You should get a feedback message similar to:

    heroku  git@heroku.com:user-agent-service.git (fetch)
    heroku  git@heroku.com:user-agent-service.git (push

# Configuration

An Elixir/Phoenix application needs to follow few conventions and needs some custom configuration to play well with Heroku. In the following chapters I'll describe how to configure your Elixir application properly.

## Elixir buildpack configuration

Heroku requires the configuration file `elixir_buildpack.conf` (in app's root directory) that basically configures the Elixir buildpack itself:

    # Erlang version
    erlang_version=17.2

    # Elixir version
    elixir_version=(branch master)

    # Rebar version
    rebar_version=(tag 2.2.0)

    # Do dependencies have to be built from scratch on every deploy?
    always_build_deps=false

In few cases we need some environment variables to be set on the Heroku instance automatically. Thus you can append these environment variables to the configuration file `elixir_buildpack.conf`. In our case we need to export the PostgreSQL database credentials as well as the session secret:

    # Export Heroku config variables
    config_vars_to_export=(DATABASE_URL SESSION_SECRET)

## Procfile

Heroku needs some information about the web processes to launch. These are defined in the `Procfile` that is also located in app's root directory:

    web: MIX_ENV=prod mix run --no-halt

In numerous cases we need consolidated protocols. To use them for our application replace the configuration line above by:

    web: MIX_ENV=prod elixir -pa _build/prod/consolidated -S mix run --no-halt

Note: if the `Procfile` is missing the default Mix task `mix server -p $PORT` will be used.

## Webapp configuration

A web application that uses the Phoenix framework can be configured via Mix configuration based on its environment. Thus first of all create the configuration directory `user_agent_service/lib/user_agent_service/config`:

    $~ cd user_agent_service
    $~ mkdir lib/user_agent_service/config

Next create the Mix configuration file `user_agent_service/lib/user_agent_service/config/config.exs`. This is the default configuration file that will be used as entry point. The environment specific configuration file will be imported therein by the last line:

    use Mix.Config

    config :phoenix, UserAgentService.Router,
      port: System.get_env("PORT"),
      ssl: false,
      cookies: true,
      session_key: "_your_app_key",
      session_secret: "super secret"

    config :phoenix, :code_reloader,
      enabled: false

    config :logger, :console,
      level: :error

    import_config "#{Mix.env}.exs"

Next configure the Elixir & Phoenix web application for every environment type. The configuration for every environment (development, test, production) differs basically in the HTTP port, the fact if modifications on code are applied immediately by reloading the entire code (good to speed up the development cycle) and the log level:

__1.) development environment in `lib/user_agent_service/config/dev.ex`:__

    use Mix.Config

    config :phoenix, UserAgentService.Router,
      port: System.get_env("PORT") || 4000,
      ssl: false,
      host: "localhost",
      cookies: true,
      session_key: "_your_app_key",
      session_secret: "$+X2PG$PX0^88^HXB)...",
      debug_errors: true

    config :phoenix, :code_reloader,
      enabled: true

    config :logger, :console,
      level: :debug

__2.) test environment in `lib/user_agent_service/config/test.ex`:__

    use Mix.Config

    config :phoenix, UserAgentService.Router,
      port: System.get_env("PORT") || 4000,
      ssl: false,
      host: "localhost",
      cookies: true,
      session_key: "_your_app_key",
      session_secret: "$+X2PG$PX0^88^HXB)...",
      debug_errors: true

    config :phoenix, :code_reloader,
      enabled: true

    config :logger, :console,
      level: :debug

__3.) production environment in `lib/user_agent_service/config/prod.ex`:__

    use Mix.Config

    config :phoenix, UserAgentService.Router,
      port: System.get_env("PORT"),
      ssl: false,
      cookies: true,
      session_key: "_your_app_key",
      session_secret: "super secret",
      debug_errors: true

    config :phoenix, :code_reloader,
      enabled: false

    config :logger, :console,
      level: :error

## Supervisor configuration

Elixir provides a very mature and rocksolid infrastructure if it's used properly. One of these functionalities that make Elixir applications that robust are supervisors. A supervisor takes over the control over a component and restarts it appropriately if the component crashes. This is the reason why Elixir works pretty well for long running services that need to be accessible throughout.

The Phoenix Mix task created the configuration file `lib/user_agent_service.ex` during the project creation initially. In our case this file looks like:

    defmodule UserAgentService do
      use Application
      def start(_type, _args) do
        import Supervisor.Spec, warn: false
        children = [
          worker(UserAgentService.Repo, [])
        ]
        opts = [strategy: :one_for_one, name: UserAgentService.Supervisor]
        Supervisor.start_link(children, opts)
      end
    end 

We will move the supervisor configuration from the file above `lib/user_agent_service.ex`:

    defmodule UserAgentService do
      use Application

      def start(_type, _args) do
        UserAgentService.Supervisor.start_link
      end
    end

... into the application supervisor `lib/user_agent_service/supervisor.ex`:

    defmodule UserAgentService.Supervisor do
      use Supervisor
      import Supervisor.Spec, warn: false

      def start_link do
        :supervisor.start_link(__MODULE__, [])
      end

      def init([]) do
        children = [
          worker(UserAgentService.Repo, []),
          worker(UserAgentService.Router, [], function: :start)
        ]
        
        opts = [strategy: :one_for_one, name: UserAgentService.Supervisor]

        supervise(children, opts)
      end
    end

# Deployment

After all the steps above has been executed and the configurations created, the time has come to deploy the application on Heroku.

First of all tell Elixir/Phoenix to run the application in production mode on the Heroku host by setting the environment variable `MIX_ENV`:

    $~ heroku config:set MIX_ENV=prod

The command should give a feedback message similar to:

    Setting config vars and restarting user-agent-service... done, v5
    MIX_ENV: prod

Before you start the deployment itself open a new shell and run the following command from the app directory to check the logs in parallel:

    $~ heroku logs --tail

Next push the repository to Heroku:

    $~ git push heroku master

This step may take a while:

    [ctp@kepler ~/projects/asconix-systems/development/user_agent_service] git push heroku master
    Initializing repository, done.
    Counting objects: 78, done.
    Delta compression using up to 8 threads.
    Compressing objects: 100% (63/63), done.
    Writing objects: 100% (78/78), 134.57 KiB | 0 bytes/s, done.
    Total 78 (delta 3), reused 0 (delta 0)

    -----> Fetching custom git buildpack... done
    -----> elixir app detected
    -----> Checking Erlang and Elixir versions
           WARNING: elixir_buildpack.config wasn't found in the app
           Using default config from Elixir buildpack
           Will use the following versions:
           * Erlang 17.2
           * Elixir branch master
           Will export the following config vars:
           * Config vars DATABASE_URL
           Downloading Erlang package
    -----> Fetching Erlang 17.2
    -----> Installing Erlang 17.2

    -----> Downloading Elixir
    -----> Installing Elixir master
    -----> Installing Hex
    * creating /app/.mix/archives/hex.ez
    ...
    Consolidated Poison.Encoder
    Consolidated Poison.Decoder
    Consolidated Plug.Exception
    Consolidated Phoenix.Html.Safe
    Consolidated Ecto.Queryable
    Consolidated String.Chars
    Consolidated Enumerable
    Consolidated Collectable
    Consolidated List.Chars
    Consolidated Inspect
    Consolidated Access
    Consolidated Range.Iterator
    Consolidated protocols written to _build/prod/consolidated
    -----> Creating .profile.d with env vars
    -----> Discovering process types
           Procfile declares types -> web

    -----> Compressing... done, 62.7MB
    -----> Launching... done, v7
           http://user-agent-service.herokuapp.com/ deployed to Heroku

    To git@heroku.com:user-agent-service.git
     * [new branch]      master -> master

The approprate log in our case looks like:

    2014-09-02T08:24:45+00:00 heroku[slug-compiler]: Slug compilation started
    2014-09-02T08:26:14.180253+00:00 heroku[router]: at=info code=H81 desc="Blank app" method=GET path="/" host=user-agent-service.herokuapp.com request_id=b85e7bc9-d86a-4e23-aec5-9b410ba732dc fwd="54.87.115.122" dyno= connect= service= status=502 bytes=
    2014-09-02T08:26:16.404719+00:00 heroku[api]: Scale to web=1 by c.pilka@asconix.com
    2014-09-02T08:26:16.898032+00:00 heroku[api]: Set DATABASE_URL config vars by c.pilka@asconix.com
    2014-09-02T08:26:16.898139+00:00 heroku[api]: Release v6 created by c.pilka@asconix.com
    2014-09-02T08:26:17.009057+00:00 heroku[api]: Attach HEROKU_POSTGRESQL_MAUVE resource by c.pilka@asconix.com
    2014-09-02T08:26:17.009129+00:00 heroku[api]: Release v7 created by c.pilka@asconix.com
    2014-09-02T08:26:17+00:00 heroku[slug-compiler]: Slug compilation finished
    2014-09-02T08:26:17.123499+00:00 heroku[api]: Deploy 1ab0b1b by c.pilka@asconix.com
    2014-09-02T08:26:17.123642+00:00 heroku[api]: Release v8 created by c.pilka@asconix.com
    2014-09-02T08:26:22.616109+00:00 heroku[web.1]: Starting process with command `MIX_ENV=prod mix run --no-halt`
    2014-09-02T08:26:24.678125+00:00 app[web.1]: Running UserAgentService.Router with Cowboy on port 11292
    2014-09-02T08:26:25.240145+00:00 heroku[web.1]: State changed from starting to up
    2014-09-02T08:26:27.099787+00:00 heroku[router]: at=info method=GET path="/" host=user-agent-service.herokuapp.com request_id=9b8276d2-27eb-46c4-96b7-37797503b2fa fwd="54.80.45.215" dyno=web.1 connect=1ms service=94ms status=200 bytes=404
    2014-09-02T08:26:27.032435+00:00 app[web.1]: 08:26:27.029 request_id=9b8276d2-27eb-46c4-96b7-37797503b2fa [info] GET 
    2014-09-02T08:26:27.098916+00:00 app[web.1]: 08:26:27.096 request_id=9b8276d2-27eb-46c4-96b7-37797503b2fa [info] Sent 200 in 67ms

# PostgreSQL

The User Agent Service uses PostgreSQL for persistent data storage. During the deployment the appropriate PostgreSQL add-on (called 'Heroku Postgres') has been provisioned automatically by the Elixir buildpack and a free `hobby-dev` database instance has been created. It should be listed at [https://postgres.heroku.com/databases](https://postgres.heroku.com/databases). 

To list the add-ons that have been provisioned automatically launch the following command:

    $~ heroku addons

In our case the only add-on that has been installed is 'Heroku Postgres':

    === user-agent-service Configured Add-ons
    heroku-postgresql:hobby-dev  HEROKU_POSTGRESQL_MAUVE

Check some general information about your PostgreSQL instance:

    $~ heroku pg:info

In our case we get the following feedback message:

    === HEROKU_POSTGRESQL_MAUVE_URL (DATABASE_URL)
    Plan:        Hobby-dev
    Status:      Available
    Connections: 0
    PG Version:  9.3.3
    Created:     2014-09-02 08:26 UTC
    Data Size:   6.5 MB
    Tables:      0
    Rows:        0/10000 (In compliance)
    Fork/Follow: Unsupported
    Rollback:    Unsupported

The deployment process automatically generates the PostgreSQL credentials as well and stores them in the `DATABASE_URL` variable. To fetch them display the app's config variables by launching the following command:

    $~ heroku config

In our case the credentials for the production database on Heroku are:

* Hostname: `ec2-54-197-239-171.compute-1.amazonaws.com`
* Port: 5432
* Database: `a22s9vqarmekt5`
* Username: `rjrivovwbrudvf`
* Password: `TePxnfRAST7_wDDtfez-cfh95Z`

Next create the appropriate database tables:

    $~ heroku run mix ecto.create UserAgentService.Repo

Login into your database:

    $~ heroku pg:psql

# Launch

To run the application please launch:

    $~ cd user_agent_service
    $~ mix phoenix.start