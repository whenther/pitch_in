defmodule PitchIn.AnswerController do
  use PitchIn.Web, :controller

  alias PitchIn.Campaign
  alias PitchIn.Ask
  alias PitchIn.Answer
  alias PitchIn.Email
  alias PitchIn.Mailer

  use PitchIn.Auth, protect: :all
  plug :check_campaign_staff
  plug :verify_campaign_staff when action in [:index]
  plug :get_answer when action in [:show, :interstitial, :update]

  def index(conn, %{"campaign_id" => campaign_id, "ask_id" => ask_id}) do
    ask = 
      Repo.get(Ask, ask_id)
      |> Repo.preload(answers: [user: :pro])
      |> Repo.preload(:campaign)
    campaign = ask.campaign

    answers = ask.answers

    if ask.campaign_id == campaign.id do
      render(conn, "index.html", campaign: campaign, ask: ask, answers: answers)
    else
      conn
      |> put_status(404)
      |> render(PitchIn.ErrorView, "404.html")
    end
  end

  def new(conn, %{"campaign_id" => campaign_id, "ask_id" => ask_id}) do
    ask = Repo.get(Ask, ask_id) |> Repo.preload(:campaign)
    campaign = ask.campaign

    changeset =
      ask
      |> build_assoc(:answers)
      |> Answer.changeset
      
    render(conn, "new.html", campaign: campaign, ask: ask, changeset: changeset)
  end

  def create(conn,
    %{
      "campaign_id" => campaign_id,
      "ask_id" => ask_id,
      "answer" => answer_params
    }) do
    ask = Repo.get(Ask, ask_id) |> Repo.preload(:campaign)
    campaign = ask.campaign
    
    changeset =
      ask
      |> build_assoc(:answers)
      |> Answer.changeset(answer_params)
      |> Ecto.Changeset.put_assoc(:user, conn.assigns.current_user)

    case Repo.insert(changeset) do
      {:ok, answer} ->
        answer = answer |> Repo.preload(user: :pro)

        Email.user_answer_email(
          conn.assigns.current_user.email,
          conn,
          campaign,
          ask,
          answer
        )
        |> Mailer.deliver_later

        Email.campaign_answer_email(
          campaign.email,
          conn,
          campaign,
          ask,
          answer
        )
        |> Mailer.deliver_later

        conn
        |> redirect(to: campaign_ask_answer_path(conn, :interstitial, campaign, ask, answer))
      {:error, changeset} ->
        render(conn, "new.html", campaign: campaign, ask: ask, changeset: changeset)
    end
  end

  def interstitial(conn,
    %{
      "campaign_id" => campaign_id,
      "ask_id" => ask_id,
      "id" => id
    }) do
    answer = conn.assigns.answer
    ask = answer.ask
    campaign = ask.campaign

    render(conn, "interstitial.html", campaign: campaign, ask: ask, answer: answer)
  end

  def show(conn,
    %{
      "campaign_id" => campaign_id,
      "ask_id" => ask_id,
      "id" => id
    }) do
    answer = conn.assigns.answer
    ask = answer.ask
    campaign = ask.campaign

    if conn.assigns.is_owner do
      render(conn, "show_to_volunteer.html", campaign: campaign, ask: ask, answer: answer)
    else
      render(conn, "show_to_campaign.html", campaign: campaign, ask: ask, answer: answer)
    end
  end

  defp get_answer(conn, _opts) do
    id = conn.params["id"]

    answer = Repo.one(
      from a in Answer,
      where: a.id == ^id,
      preload: [ask: :campaign],
      preload: [user: :pro]
    )

    is_owner = answer.user_id == conn.assigns.current_user.id
    is_staff = conn.assigns.is_staff

    if is_owner || is_staff do
      conn
      |> Plug.Conn.assign(:answer, answer)
      |> Plug.Conn.assign(:is_owner, is_owner)
    else
      conn
      |> put_status(404)
      |> Phoenix.Controller.render(PitchIn.ErrorView, "404.html")
      |> halt
    end

  end
end
