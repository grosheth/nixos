{ pkgs, ...}
{
    pkgs.rust-bin.stable.latest.default.override {
        extensions = [
        "rust-src" # needed by rust-analyzer vscode extension when installed through internet
        "rust-analyzer" 
        ];
        targets = ["wasm32-unknown-emscripten"];
    }
}