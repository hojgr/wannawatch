defmodule Wannawatch.ErrorHelpers do
  @moduledoc """
  Conveniences for translating and building error messages.
  """
  use Phoenix.HTML

  @doc """
  Generates tag for inlined form input errors.
  """
  def form_error_tag(form, field, tag \\ :span) do
    if error = form.errors[field] do
      content_tag tag, translate_error(error), class: "help-block"
    end
  end

  def error_tag(message, tag \\ :li) do
    content_tag tag, translate_error(message)
  end

  @doc """
  Translates an error message using gettext.
  """
  def translate_error({msg, opts}) do
    # Because error messages were defined within Ecto, we must
    # call the Gettext module passing our Gettext backend. We
    # also use the "errors" domain as translations are placed
    # in the errors.po file. On your own code and templates,
    # this could be written simply as:
    #
    #     dngettext "errors", "1 file", "%{count} files", count
    #
    Gettext.dngettext(Wannawatch.Gettext, "errors", msg, msg, opts[:count], opts)
  end

  def translate_error(msg) do
    Gettext.dgettext(Wannawatch.Gettext, "errors", msg)
  end
end
