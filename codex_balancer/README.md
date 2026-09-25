# Codex Balancer screen

This private TRMNL plugin polls the hosted balancer's `/stats` endpoint and shows estimated monthly API value, monthly input and output tokens, weekly capacity, banked resets per account, reset countdowns, and each account's share of traffic over the last 24 hours on a full-size screen. The footer shows the screen render time in the account's local timezone.

1. Create a Private Plugin with the Polling strategy in your TRMNL account. An official device needs the Developer add-on or Developer Edition to create private plugins.
2. Copy the fields from `settings.yml` into the plugin settings. Use the configured polling URL and a fifteen-minute refresh interval.
3. Paste `shared.liquid` into Shared and `full.liquid` into Full in the markup editor.
4. Force Refresh to fetch data, preview the full layout, then add the plugin to the device playlist.

The balancer's `/stats` endpoint is currently reachable without authentication and returns masked account emails. TRMNL's server fetches and renders this data, so the endpoint must remain publicly reachable for polling to work. The screen shows the first ten accounts if the pool contains more than ten.

The monthly values, reset countdowns, and traffic shares require a balancer version that includes `monthly_api_cost`, `monthly_input_tokens`, `monthly_output_tokens`, `reset_in`, and `traffic_24h_percent` in `/stats`. Older versions show a dash for unavailable values until updated.
