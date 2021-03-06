# This file is used by Rack-based servers to start the application.

require ::File.expand_path("../config/environment",  __FILE__)
require ::File.expand_path("../lib/rack/internet_explorer_version", __FILE__)

# Kill unicorn workers really aggressively (at 300mb)
if defined?(Unicorn)
  require "unicorn/worker_killer"
  oom_min = (280) * (1024**2)
  oom_max = (300) * (1024**2)
  # Max memory size (RSS) per worker
  use Unicorn::WorkerKiller::Oom, oom_min, oom_max
end
use Rack::Deflater
use Rack::InternetExplorerVersion, minimum: 9

run Diaspora::Application
