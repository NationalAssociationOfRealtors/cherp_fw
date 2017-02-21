defmodule CherpFw.Mixfile do
  use Mix.Project

  @target System.get_env("NERVES_TARGET") || "rpi3"

  def project do
    [app: :cherp_fw,
     version: "0.0.1",
     target: @target,
     archives: [nerves_bootstrap: "~> 0.2.1"],
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     aliases: aliases(),
     deps: deps() ++ system(@target)]
  end

  def application do
    [
      mod: {CherpFw.Application, []},
      applications: [
        :logger,
        :nerves,
        :nerves_system_rpi3,
        :nerves_firmware_http,
        :event_manager,
        :network_manager,
        :cpu_mon,
        :device_manager,
        :data_manager,
        :api,
        :rosetta_home_chromecast,
        :rosetta_home_radio_thermostat,
        :rosetta_home_ieq_sensor,
        :rosetta_home_lifx,
        :rosetta_home_raven_smcd,
        :rosetta_home_meteo_stick,
      ],
      env: [
        cipher: [
          keyphrase: System.get_env("CIPHER_KEYPHRASE"),
          ivphrase: System.get_env("CIPHER_IV"),
          magic_token: System.get_env("CIPHER_TOKEN")
        ]
      ]
   ]
  end

  defp deps do
    [
      {:nerves, github: "nerves-project/nerves", tag: "master", override: true},
      {:nerves_firmware_http, github: "nerves-project/nerves_firmware_http"},
      {:distillery, "~>1.1.2"},
      {:poison, "~> 3.0", override: true},
      {:cicada, github: "rosetta-home/cicada", branch: "dependency", override: true},
      {:rosetta_home_chromecast, github: "rosetta-home/rosetta_home_chromecast"},
      {:rosetta_home_radio_thermostat, github: "rosetta-home/rosetta_home_radio_thermostat"},
      {:rosetta_home_ieq_sensor, github: "rosetta-home/rosetta_home_ieq_sensor"},
      {:rosetta_home_lifx, github: "rosetta-home/rosetta_home_lifx"},
      {:rosetta_home_raven_smcd, github: "rosetta-home/rosetta_home_raven_smcd"},
      {:rosetta_home_meteo_stick, github: "rosetta-home/rosetta_home_meteo_stick"},
    ]
  end

  def system("rpi3") do
    [{:"nerves_system_rpi3", git: "https://github.com/NationalAssociationOfRealtors/nerves_system_rpi3.git", tag: "v0.10.2-dev" }]
  end

  def aliases do
    ["deps.precompile": ["nerves.precompile", "deps.precompile"],
     "deps.loadpaths":  ["deps.loadpaths", "nerves.loadpaths"]]
  end
end
