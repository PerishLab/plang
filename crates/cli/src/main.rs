#![forbid(unsafe_code)]

use clap::Parser;

#[derive(Parser)]
#[command(
    name = "plang",
    version = plumb::version!("PLANG"),
    about = "plang command-line boundary"
)]
struct Cli;

fn main() {
    debug_assert_eq!(plang_api::VERSION, env!("CARGO_PKG_VERSION"));
    Cli::parse();
}
