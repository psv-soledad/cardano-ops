pkgs:
let
  requireEnv = name:
    let value = builtins.getEnv name;
    in if value == "" then
      abort "${name} environment variable is not set"
    else
      value;
in {

  static = import ./static;

  deploymentName = "${builtins.baseNameOf ./.}";

  environmentName = pkgs.globals.deploymentName;

  sourcesJsonOverride = ./nix + "/sources.${pkgs.globals.environmentName}.json";

  dnsZone = "dev.cardano.org";
  domain = "${pkgs.globals.deploymentName}.${pkgs.globals.dnsZone}";
  relaysNew = pkgs.globals.environmentConfig.relaysNew or "relays-new.${pkgs.globals.domain}";

  explorerHostName = "explorer";
  explorerForceSSL = true;
  explorerAliases = [];

  withMonitoring = true;
  withExplorer = true;
  withCardanoDBExtended = true;
  withSubmitApi = false;
  withFaucet = false;
  withFaucetOptions = {};
  withSmash = false;

  initialPythonExplorerDBSyncDone = false;

  withHighCapacityMonitoring = false;
  withHighCapacityExplorer = false;
  withHighLoadRelays = false;

  environments = pkgs.iohkNix.cardanoLib.environments;

  environmentConfig = pkgs.globals.environments.${pkgs.globals.environmentName};

  deployerIp = requireEnv "DEPLOYER_IP";
  cardanoNodePort = 3001;

  cardanoNodePrometheusExporterPort = 12798;
  cardanoExplorerPrometheusExporterPort = 8080;
  netdataExporterPort = 19999;

  extraPrometheusExportersPorts = [
    pkgs.globals.cardanoNodePrometheusExporterPort
    pkgs.globals.cardanoExplorerPrometheusExporterPort
    pkgs.globals.netdataExporterPort
  ];

  alertChainDensityLow = "99";
  alertMemPoolHigh = "190";
  alertTcpHigh = "120";
  alertTcpCrit = "150";
  alertMbpsHigh = "150";
  alertMbpsCrit = "200";
}
