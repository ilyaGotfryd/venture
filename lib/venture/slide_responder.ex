defmodule Venture.SlideResponder do
  use Hedwig.Responder

  hear ~r/current slide/, msg do
    %{ location: %{ index: current_slide} } = Venture.Presentation.current_slide
    reply msg, "The current slide is #{current_slide}"
  end

  hear ~r/nice work/i, msg do
    reply msg, "Venturebot lives to serve."
  end
end
