class SparklineChannel < ApplicationCable::Channel
  def subscribed
    stream_from "sparkline"
  end
end
