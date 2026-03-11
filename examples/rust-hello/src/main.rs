use anyhow::{Context, Result};
use serde_json::Value;

fn main() -> Result<()> {
    let payload: Value = serde_json::from_str(r#"{"service":"rust-hello","ok":true}"#)
        .context("failed to parse example JSON payload")?;

    println!("hello from {} example", payload["service"]);
    Ok(())
}
