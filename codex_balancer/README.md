# Codex Balancer screen

This private TRMNL plugin polls the hosted balancer's `/stats` endpoint and shows estimated monthly API value, weekly capacity, reset times, and banked resets on a full-size screen. The money figure uses the same pricing estimate as the balancer dashboard; it is not a bill.

1. Create a Private Plugin with the Polling strategy in your TRMNL account. An official device needs the Developer add-on or Developer Edition to create private plugins.
2. Copy the fields from `settings.yml` into the plugin settings. Use the configured polling URL and a fifteen-minute refresh interval.
3. Paste `shared.liquid` into Shared and `full.liquid` into Full in the markup editor.
4. Force Refresh to fetch data, preview the full layout, then add the plugin to the device playlist.

The balancer's `/stats` endpoint is currently reachable without authentication and returns masked account emails. TRMNL's server fetches and renders this data, so the endpoint must remain publicly reachable for polling to work. The screen shows the first ten accounts if the pool contains more than ten.

The monthly value requires a balancer version that includes `monthly_api_cost` in `/stats`. Older versions show a dash until updated.
