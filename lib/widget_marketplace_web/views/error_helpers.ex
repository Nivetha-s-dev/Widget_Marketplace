defmodule WidgetMarketplaceWeb.ErrorHelpers do
  @moduledoc

  use Phoenix.HTML

  @doc
  def error_tag(form, field) do
    Enum.map(Keyword.get_values(form.errors, field), fn error ->
      content_tag(:span, translate_error(error),
        class: "invalid-feedback",
        phx_feedback_for: input_id(form, field)
      )
    end)
  end

  @doc
  def translate_error({msg, opts}) do

    if count = opts[:count] do
      Gettext.dngettext(WidgetMarketplaceWeb.Gettext, "errors", msg, msg, count, opts)
    else
      Gettext.dgettext(WidgetMarketplaceWeb.Gettext, "errors", msg, opts)
    end
  end
end
