Rails.application.config.after_initialize do
  if Rails.env.production? || ENV["CI"] == "true"
    DownloadAndExtractMaxmindFileJob.perform_now
  else
    DownloadAndExtractMaxmindFileJob.perform_later
  end
end
