class SparklineComponent < ApplicationComponent
  def initialize(values: nil, width: 100, height: 30, stroke_width: 3, color: "green", filled: true)
    @values = values
    @width = width
    @height = height
    @stroke_width = stroke_width
    @color = color
    @filled = filled
  end

  private

  attr_reader :width, :height, :stroke_width, :color, :filled, :values

  def svg_classes
    "sparkline sparkline--#{color}#{" sparkline--filled" if filled}"
  end

  def render?
    !values.nil?
  end
end
