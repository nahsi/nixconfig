{ inputs, system, ... }:
{
  imports = [ inputs.hermes-agent.homeManagerModules.default ];

  programs.hermes-agent = {
    package = inputs.hermes-agent.packages.${system}.minimal;
    desktop.enable = true;
  };
}
