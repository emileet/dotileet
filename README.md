# .dotileet

emileet's nixos system configurations

## setup

### fresh

assuming your system is partitioned correctly (refer to `./hosts/HOSTNAME/hardware/default.nix`):

```shell
sudo nixos-install --flake https://github.com/emileet/dotileet#HOSTNAME
```

### existing

assuming you have a flake enabled nix system:

```shell
sudo nixos-rebuild switch --flake .#HOSTNAME
```

## hosts

| hostname | description         |
| -------- | ------------------- |
| nix      | threadripper server |
| nixsrv   | vm server           |
| shodan   | primary desktop     |

## configuration structure

- `flake.nix`: entrypoint containing the inputs used to construct defined `nixosConfigurations`
- `modules/`: reusable nixpkgs modules
- `hosts/`: host-specific configurations
- `home/`: reusable home manager modules and shared settings
- `pkgs/system.nix`: system packages/programs
- `pkgs/user.nix`: home manager packages/programs
- `pkgs/overlays/include.nix`: adds non-upstream packages
- `pkgs/overlays/modify.nix`: overrides upstream packages
