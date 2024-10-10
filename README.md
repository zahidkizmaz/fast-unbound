## Example Usage

```nix
{
  inputs.fast-unbound-flake.url="github:zahidkizmaz/fast-unbound";

  outputs={ self, nixpkgs, fast-unbound,... }: {

    nixosConfigurations.myhost=nixpkgs.lib.nixosSystem{
       # ... other configuration ...
       modules=[
         fast-unbound-flake.nixosModules.${pkgs.system}.fast-unbound-container
         ({config,...}:{
           services.fast-unound-container={
             enable=true;
             unboundConfigPath="/path/to/unbound.conf";
             valkeyDbPath="/path/to/valkey/db";
           };
         })
       ];
     };
   };
}
```
